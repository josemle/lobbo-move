/// This module provides the foundation for typesafe Coins.
module aptos_framework::coin {
  use std::string;
  use std::error;
  use std::option::{Self, Option};
  use std::signer;

  use aptos_framework::account;
  use aptos_framework::aggregator_factory;
  use aptos_framework::aggregator::{Self, Aggregator};
  use aptos_framework::event::{Self, EventHandle};
  use aptos_framework::optional_aggregator::{Self, OptionalAggregator};
  use aptos_framework::system_addresses;

  use aptos_std::type_info;

  friend aptos_framework::aptos_coin;
  friend aptos_framework::genesis;
  friend aptos_framework::transaction_fee;

  //
  // Errors.
  //

  /// Address of account which is used to initialize a coin `CoinType` doesn't match the deployer of module
  const ECOIN_INFO_ADDRESS_MISMATCH: u64 = 1;

  /// `CoinType` is already initialized as a coin
  const ECOIN_INFO_ALREADY_PUBLISHED: u64 = 2;

  /// `CoinType` hasn't been initialized as a coin
  const ECOIN_INFO_NOT_PUBLISHED: u64 = 3;

  /// Deprecated. Account already has `CoinStore` registered for `CoinType`
  const ECOIN_STORE_ALREADY_PUBLISHED: u64 = 4;

  /// Account hasn't registered `CoinStore` for `CoinType`
  const ECOIN_STORE_NOT_PUBLISHED: u64 = 5;

  /// Not enough coins to complete transaction
  const EINSUFFICIENT_BALANCE: u64 = 6;

  /// Cannot destroy non-zero coins
  const EDESTRUCTION_OF_NONZERO_TOKEN: u64 = 7;

  /// Coin amount cannot be zero
  const EZERO_COIN_AMOUNT: u64 = 9;

  /// CoinStore is frozen. Coins cannot be deposited or withdrawn
  const EFROZEN: u64 = 10;

  /// Cannot upgrade the total supply of coins to different implementation.
  const ECOIN_SUPPLY_UPGRADE_NOT_SUPPORTED: u64 = 11;

  /// Name of the coin is too long
  const ECOIN_NAME_TOO_LONG: u64 = 12;

  /// Symbol of the coin is too long
  const ECOIN_SYMBOL_TOO_LONG: u64 = 13;

  /// The value of aggregatable coin used for transaction fees redistribution does not fit in u64.
  const EAGGREGATABLE_COIN_VALUE_TOO_LARGE: u64 = 14;

  //
  // Constants
  //

  const MAX_COIN_NAME_LENGTH: u64 = 32;
  const MAX_COIN_SYMBOL_LENGTH: u64 = 10;

  /// Core data structures

  /// Main structure representing a coin/token in an account's custody.
  struct Coin<phantom CoinType> has store {
    /// Amount of coin this address has.
    value: u64,
  }

  /// Represents a coin with aggregator as its value. This allows to update
  /// the coin in every transaction avoiding read-modify-write conflicts. Only
  /// used for gas fees distribution by Aptos Framework (0x1).
  struct AggregatableCoin<phantom CoinType> has store {
    /// Amount of aggregatable coin this address has.
    value: Aggregator,
  }

  /// Maximum possible aggregatable coin value.
  const MAX_U64: u128 = 18446744073709551615;

  /// A holder of a specific coin types and associated event handles.
  /// These are kept in a single resource to ensure locality of data.
  struct CoinStore<phantom CoinType> has key {
    coin: Coin<CoinType>,
    frozen: bool,
    deposit_events: EventHandle<DepositEvent>,
    withdraw_events: EventHandle<WithdrawEvent>,
  }

  /// Maximum possible coin supply.
  const MAX_U128: u128 = 340282366920938463463374607431768211455;

  /// Configuration that controls the behavior of total coin supply. If the field
  /// is set, coin creators are allowed to upgrade to parallelizable implementations.
  struct SupplyConfig has key {
    allow_upgrades: bool,
  }

  /// Information about a specific coin type. Stored on the creator of the coin's account.
  struct CoinInfo<phantom CoinType> has key {
    name: string::String,
    /// Symbol of the coin, usually a shorter version of the name.
    /// For example, Singapore Dollar is SGD.
    symbol: string::String,
    /// Number of decimals used to get its user representation.
    /// For example, if `decimals` equals `2`, a balance of `505` coins should
    /// be displayed to a user as `5.05` (`505 / 10 ** 2`).
    decimals: u8,
    /// Amount of this coin type in existence.
    supply: Option<OptionalAggregator>,
  }

  /// Event emitted when some amount of a coin is deposited into an account.
  struct DepositEvent has drop, store {
    amount: u64,
  }

  /// Event emitted when some amount of a coin is withdrawn from an account.
  struct WithdrawEvent has drop, store {
    amount: u64,
  }

  /// Capability required to mint coins.
  struct MintCapability<phantom CoinType> has copy, store {}

  /// Capability required to freeze a coin store.
  struct FreezeCapability<phantom CoinType> has copy, store {}

  /// Capability required to burn coins.
  struct BurnCapability<phantom CoinType> has copy, store {}

  //
  // Total supply config
  //

  /// Publishes supply configuration. Initially, upgrading is not allowed.
  public(friend) fun initialize_supply_config(aptos_framework: &signer) {
    system_addresses::assert_aptos_framework(aptos_framework);
    move_to(aptos_framework, SupplyConfig { allow_upgrades: false });
  }

  /// This should be called by on-chain governance to update the config and allow
  // or disallow upgradability of total supply.
  public fun allow_supply_upgrades(aptos_framework: &signer, allowed: bool) acquires SupplyConfig {
    system_addresses::assert_aptos_framework(aptos_framework);
    let allow_upgrades = &mut borrow_global_mut<SupplyConfig>(@aptos_framework).allow_upgrades;
    *allow_upgrades = allowed;
  }

  //
  //  Aggregatable coin functions
  //

  /// Creates a new aggregatable coin with value overflowing on `limit`. Note that this function can
  /// only be called by Aptos Framework (0x1) account for now becuase of `create_aggregator`.
  public(friend) fun initialize_aggregatable_coin<CoinType>(aptos_framework: &signer): AggregatableCoin<CoinType> {
    let aggregator = aggregator_factory::create_aggregator(aptos_framework, MAX_U64);
    AggregatableCoin<CoinType> {
      value: aggregator,
    }
  }

  /// Returns true if the value of aggregatable coin is zero.
  public(friend) fun is_aggregatable_coin_zero<CoinType>(coin: &AggregatableCoin<CoinType>): bool {
    let amount = aggregator::read(&coin.value);
    amount == 0
  }

  /// Drains the aggregatable coin, setting it to zero and returning a standard coin.
  public(friend) fun drain_aggregatable_coin<CoinType>(coin: &mut AggregatableCoin<CoinType>): Coin<CoinType> {
    spec {
      // TODO: The data invariant is not properly assumed from CollectedFeesPerBlock.
      assume aggregator::spec_get_limit(coin.value) == MAX_U64;
    };
    let amount = aggregator::read(&coin.value);
    assert!(amount <= MAX_U64, error::out_of_range(EAGGREGATABLE_COIN_VALUE_TOO_LARGE));

    aggregator::sub(&mut coin.value, amount);
    Coin<CoinType> {
      value: (amount as u64),
    }
  }

  /// Merges `coin` into aggregatable coin (`dst_coin`).
  public(friend) fun merge_aggregatable_coin<CoinType>(dst_coin: &mut AggregatableCoin<CoinType>, coin: Coin<CoinType>) {
    let Coin { value } = coin;
    let amount = (value as u128);
    aggregator::add(&mut dst_coin.value, amount);
  }

  /// Collects a specified amount of coin form an account into aggregatable coin.
  public(friend) fun collect_into_aggregatable_coin<CoinType>(
    account_addr: address,
    amount: u64,
    dst_coin: &mut AggregatableCoin<CoinType>,
  ) acquires CoinStore {
    // Skip collecting if amount is zero.
    if (amount == 0) {
      return
    };

    let coin_store = borrow_global_mut<CoinStore<CoinType>>(account_addr);
    let coin = extract(&mut coin_store.coin, amount);
    merge_aggregatable_coin(dst_coin, coin);
  }

  //
  // Getter functions
  //

  /// A helper function that returns the address of CoinType.
  fun coin_address<CoinType>(): address {
    let type_info = type_info::type_of<CoinType>();
    type_info::account_address(&type_info)
  }

  #[view]
  /// Returns the balance of `owner` for provided `CoinType`.
  public fun balance<CoinType>(owner: address): u64 acquires CoinStore {
    assert!(
      is_account_registered<CoinType>(owner),
      error::not_found(ECOIN_STORE_NOT_PUBLISHED),
    );
    borrow_global<CoinStore<CoinType>>(owner).coin.value
  }

  #[view]
  /// Returns `true` if the type `CoinType` is an initialized coin.
  public fun is_coin_initialized<CoinType>(): bool {
    exists<CoinInfo<CoinType>>(coin_address<CoinType>())
  }

  #[view]
  /// Returns `true` if `account_addr` is registered to receive `CoinType`.
  public fun is_account_registered<CoinType>(account_addr: address): bool {
    exists<CoinStore<CoinType>>(account_addr)
  }

  #[view]
  /// Returns the name of the coin.
  public fun name<CoinType>(): string::String acquires CoinInfo {
    borrow_global<CoinInfo<CoinType>>(coin_address<CoinType>()).name
  }

  #[view]
  /// Returns the symbol of the coin, usually a shorter version of the name.
  public fun symbol<CoinType>(): string::String acquires CoinInfo {
    borrow_global<CoinInfo<CoinType>>(coin_address<CoinType>()).symbol
  }

  #[view]
  /// Returns the number of decimals used to get its user representation.
  /// For example, if `decimals` equals `2`, a balance of `505` coins should
  /// be displayed to a user as `5.05` (`505 / 10 ** 2`).
  public fun decimals<CoinType>(): u8 acquires CoinInfo {
    borrow_global<CoinInfo<CoinType>>(coin_address<CoinType>()).decimals
  }

  #[view]
  /// Returns the amount of coin in existence.
  public fun supply<CoinType>(): Option<u128> acquires CoinInfo {
    let maybe_supply = &borrow_global<CoinInfo<CoinType>>(coin_address<CoinType>()).supply;
    if (option::is_some(maybe_supply)) {
      // We do track supply, in this case read from optional aggregator.
      let supply = option::borrow(maybe_supply);
      let value = optional_aggregator::read(supply);
      option::some(value)
    } else {
      option::none()
    }
  }

  // Public functions
  /// Burn `coin` with capability.
  /// The capability `_cap` should be passed as a reference to `BurnCapability<CoinType>`.
  public fun burn<CoinType>(
    coin: Coin<CoinType>,
    _cap: &BurnCapability<CoinType>,
  ) acquires CoinInfo {
    let Coin { value: amount } = coin;
    assert!(amount > 0, error::invalid_argument(EZERO_COIN_AMOUNT));

    let maybe_supply = &mut borrow_global_mut<CoinInfo<CoinType>>(coin_address<CoinType>()).supply;
    if (option::is_some(maybe_supply)) {
      let supply = option::borrow_mut(maybe_supply);
      optional_aggregator::sub(supply, (amount as u128));
    }
  }

  /// Burn `coin` from the specified `account` with capability.
  /// The capability `burn_cap` should be passed as a reference to `BurnCapability<CoinType>`.
  /// This function shouldn't fail as it's called as part of transaction fee burning.
  ///
  /// Note: This bypasses CoinStore::frozen -- coins within a frozen CoinStore can be burned.
  public fun burn_from<CoinType>(
    account_addr: address,
    amount: u64,
    burn_cap: &BurnCapability<CoinType>,
  ) acquires CoinInfo, CoinStore {
    // Skip burning if amount is zero. This shouldn't error out as it's called as part of transaction fee burning.
    if (amount == 0) {
      return
    };

    let coin_store = borrow_global_mut<CoinStore<CoinType>>(account_addr);
    let coin_to_burn = extract(&mut coin_store.coin, amount);
    burn(coin_to_burn, burn_cap);
  }

  /// Deposit the coin balance into the recipient's account and emit an event.
  public fun deposit<CoinType>(account_addr: address, coin: Coin<CoinType>) acquires CoinStore {
    assert!(
      is_account_registered<CoinType>(account_addr),
      error::not_found(ECOIN_STORE_NOT_PUBLISHED),
    );

    let coin_store = borrow_global_mut<CoinStore<CoinType>>(account_addr);
    assert!(
      !coin_store.frozen,
      error::permission_denied(EFROZEN),
    );

    event::emit_event<DepositEvent>(
      &mut coin_store.deposit_events,
      DepositEvent { amount: coin.value },
    );

    merge(&mut coin_store.coin, coin);
  }

  /// Destroys a zero-value coin. Calls will fail if the `value` in the passed-in `token` is non-zero
  /// so it is impossible to "burn" any non-zero amount of `Coin` without having
  /// a `BurnCapability` for the specific `CoinType`.
  public fun destroy_zero<CoinType>(zero_coin: Coin<CoinType>) {
    let Coin { value } = zero_coin;
    assert!(value == 0, error::invalid_argument(EDESTRUCTION_OF_NONZERO_TOKEN))
  }

  /// Extracts `amount` from the passed-in `coin`, where the original token is modified in place.
  public fun extract<CoinType>(coin: &mut Coin<CoinType>, amount: u64): Coin<CoinType> {
    assert!(coin.value >= amount, error::invalid_argument(EINSUFFICIENT_BALANCE));
    coin.value = coin.value - amount;
    Coin { value: amount }
  }

  /// Extracts the entire amount from the passed-in `coin`, where the original token is modified in place.
  public fun extract_all<CoinType>(coin: &mut Coin<CoinType>): Coin<CoinType> {
    let total_value = coin.value;
    coin.value = 0;
    Coin { value: total_value }
  }

  #[legacy_entry_fun]
  /// Freeze a CoinStore to prevent transfers
  public entry fun freeze_coin_store<CoinType>(
    account_addr: address,
    _freeze_cap: &FreezeCapability<CoinType>,
  ) acquires CoinStore {
    let coin_store = borrow_global_mut<CoinStore<CoinType>>(account_addr);
    coin_store.frozen = true;
  }

  #[legacy_entry_fun]
  /// Unfreeze a CoinStore to allow transfers
  public entry fun unfreeze_coin_store<CoinType>(
    account_addr: address,
    _freeze_cap: &FreezeCapability<CoinType>,
  ) acquires CoinStore {
    let coin_store = borrow_global_mut<CoinStore<CoinType>>(account_addr);
    coin_store.frozen = false;
  }

  /// Upgrade total supply to use a parallelizable implementation if it is
  /// available.
  public entry fun upgrade_supply<CoinType>(account: &signer) acquires CoinInfo, SupplyConfig {
    let account_addr = signer::address_of(account);

    // Only coin creators can upgrade total supply.
    assert!(
      coin_address<CoinType>() == account_addr,
      error::invalid_argument(ECOIN_INFO_ADDRESS_MISMATCH),
    );

    // Can only succeed once on-chain governance agreed on the upgrade.
    assert!(
      borrow_global_mut<SupplyConfig>(@aptos_framework).allow_upgrades,
      error::permission_denied(ECOIN_SUPPLY_UPGRADE_NOT_SUPPORTED)
    );

    let maybe_supply = &mut borrow_global_mut<CoinInfo<CoinType>>(account_addr).supply;
    if (option::is_some(maybe_supply)) {
      let supply = option::borrow_mut(maybe_supply);

      // If supply is tracked and the current implementation uses an integer - upgrade.
      if (!optional_aggregator::is_parallelizable(supply)) {
        optional_aggregator::switch(supply);
      }
    }
  }

  /// Creates a new Coin with given `CoinType` and returns minting/freezing/burning capabilities.
  /// The given signer also becomes the account hosting the information  about the coin
  /// (name, supply, etc.). Supply is initialized as non-parallelizable integer.
  public fun initialize<CoinType>(
    account: &signer,
    name: string::String,
    symbol: string::String,
    decimals: u8,
    monitor_supply: bool,
  ): (BurnCapability<CoinType>, FreezeCapability<CoinType>, MintCapability<CoinType>) {
    initialize_internal(account, name, symbol, decimals, monitor_supply, false)
  }

  /// Same as `initialize` but supply can be initialized to parallelizable aggregator.
  public(friend) fun initialize_with_parallelizable_supply<CoinType>(
    account: &signer,
    name: string::String,
    symbol: string::String,
    decimals: u8,
    monitor_supply: bool,
  ): (BurnCapability<CoinType>, FreezeCapability<CoinType>, MintCapability<CoinType>) {
    system_addresses::assert_aptos_framework(account);
    initialize_internal(account, name, symbol, decimals, monitor_supply, true)
  }

  fun initialize_internal<CoinType>(
    account: &signer,
    name: string::String,
    symbol: string::String,
    decimals: u8,
    monitor_supply: bool,
    parallelizable: bool,
  ): (BurnCapability<CoinType>, FreezeCapability<CoinType>, MintCapability<CoinType>) {
    let account_addr = signer::address_of(account);

    assert!(
      coin_address<CoinType>() == account_addr,
      error::invalid_argument(ECOIN_INFO_ADDRESS_MISMATCH),
    );

    assert!(
      !exists<CoinInfo<CoinType>>(account_addr),
      error::already_exists(ECOIN_INFO_ALREADY_PUBLISHED),
    );

    assert!(string::length(&name) <= MAX_COIN_NAME_LENGTH, error::invalid_argument(ECOIN_NAME_TOO_LONG));
    assert!(string::length(&symbol) <= MAX_COIN_SYMBOL_LENGTH, error::invalid_argument(ECOIN_SYMBOL_TOO_LONG));

    let coin_info = CoinInfo<CoinType> {
      name,
      symbol,
      decimals,
      supply: if (monitor_supply) { option::some(optional_aggregator::new(MAX_U128, parallelizable)) } else { option::none() },
    };
    move_to(account, coin_info);

    (BurnCapability<CoinType> {}, FreezeCapability<CoinType> {}, MintCapability<CoinType> {})
  }

  /// "Merges" the two given coins.  The coin passed in as `dst_coin` will have a value equal
  /// to the sum of the two tokens (`dst_coin` and `source_coin`).
  public fun merge<CoinType>(dst_coin: &mut Coin<CoinType>, source_coin: Coin<CoinType>) {
    spec {
      assume dst_coin.value + source_coin.value <= MAX_U64;
    };
    let Coin { value } = source_coin;
    dst_coin.value = dst_coin.value + value;
  }

  /// Mint new `Coin` with capability.
  /// The capability `_cap` should be passed as reference to `MintCapability<CoinType>`.
  /// Returns minted `Coin`.
  public fun mint<CoinType>(
    amount: u64,
    _cap: &MintCapability<CoinType>,
  ): Coin<CoinType> acquires CoinInfo {
    if (amount == 0) {
      return zero<CoinType>()
    };

    let maybe_supply = &mut borrow_global_mut<CoinInfo<CoinType>>(coin_address<CoinType>()).supply;
    if (option::is_some(maybe_supply)) {
      let supply = option::borrow_mut(maybe_supply);
      optional_aggregator::add(supply, (amount as u128));
    };

    Coin<CoinType> { value: amount }
  }

  public fun register<CoinType>(account: &signer) {
    let account_addr = signer::address_of(account);
    // Short-circuit and do nothing if account is already registered for CoinType.
    if (is_account_registered<CoinType>(account_addr)) {
      return
    };

    account::register_coin<CoinType>(account_addr);
    let coin_store = CoinStore<CoinType> {
      coin: Coin { value: 0 },
      frozen: false,
      deposit_events: account::new_event_handle<DepositEvent>(account),
      withdraw_events: account::new_event_handle<WithdrawEvent>(account),
    };
    move_to(account, coin_store);
  }

  /// Transfers `amount` of coins `CoinType` from `from` to `to`.
  public entry fun transfer<CoinType>(
    from: &signer,
    to: address,
    amount: u64,
  ) acquires CoinStore {
    let coin = withdraw<CoinType>(from, amount);
    deposit(to, coin);
  }

  /// Returns the `value` passed in `coin`.
  public fun value<CoinType>(coin: &Coin<CoinType>): u64 {
    coin.value
  }

  /// Withdraw specifed `amount` of coin `CoinType` from the signing account.
  public fun withdraw<CoinType>(
    account: &signer,
    amount: u64,
  ): Coin<CoinType> acquires CoinStore {
    let account_addr = signer::address_of(account);
    assert!(
      is_account_registered<CoinType>(account_addr),
      error::not_found(ECOIN_STORE_NOT_PUBLISHED),
    );

    let coin_store = borrow_global_mut<CoinStore<CoinType>>(account_addr);
    assert!(
      !coin_store.frozen,
      error::permission_denied(EFROZEN),
    );

    event::emit_event<WithdrawEvent>(
      &mut coin_store.withdraw_events,
      WithdrawEvent { amount },
    );

    extract(&mut coin_store.coin, amount)
  }

  /// Create a new `Coin<CoinType>` with a value of `0`.
  public fun zero<CoinType>(): Coin<CoinType> {
    Coin<CoinType> {
      value: 0
    }
  }

  /// Destroy a freeze capability. Freeze capability is dangerous and therefore should be destroyed if not used.
  public fun destroy_freeze_cap<CoinType>(freeze_cap: FreezeCapability<CoinType>) {
    let FreezeCapability<CoinType> {} = freeze_cap;
  }

  /// Destroy a mint capability.
  public fun destroy_mint_cap<CoinType>(mint_cap: MintCapability<CoinType>) {
    let MintCapability<CoinType> {} = mint_cap;
  }

  /// Destroy a burn capability.
  public fun destroy_burn_cap<CoinType>(burn_cap: BurnCapability<CoinType>) {
    let BurnCapability<CoinType> {} = burn_cap;
  }
}
