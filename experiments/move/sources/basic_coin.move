/// This module defines a minimal and generic Coin and Balance.
module deploy_address::BasicCoin {
  use std::signer;

  /// Error codes
  const ENOT_MODULE_OWNER: u64 = 0;
  const EINSUFFICIENT_BALANCE: u64 = 1;
  const EALREADY_HAS_BALANCE: u64 = 2;
  const EALREADY_INITIALIZED: u64 = 3;
  const EEQUAL_ADDR: u64 = 4;

  struct Coin<phantom CoinType> has store {
    value: u64
  }

  struct Balance<phantom CoinType> has key {
    coin: Coin<CoinType>
  }

  public fun publish_balance<CoinType>(account: &signer) {
    let empty_coin = Coin<CoinType> { value: 0 };
    assert!(!exists<Balance<CoinType>>(signer::address_of(account)), EALREADY_HAS_BALANCE);
    move_to(account, Balance<CoinType> { coin: empty_coin });
  }
  
  /// Mint `amount` tokens to `mint_addr`. This method requires a witness with `CoinType` so that the
  /// module that owns `CoinType` can decide the minting policy.
  public fun mint<CoinType: drop>(mint_addr: address, amount: u64, _witness: CoinType) acquires Balance {
    // Deposit `total_value` amount of tokens to mint_addr's balance
    deposit(mint_addr, Coin<CoinType> { value: amount });
  }

  public fun balance_of<CoinType>(owner: address): u64 acquires Balance {
    borrow_global<Balance<CoinType>>(owner).coin.value
  }

  /// Transfers `amount` of tokens from `from` to `to`. This method requires a witness with `CoinType` so that the
  /// module that owns `CoinType` can decide the transferring policy.
  public fun transfer<CoinType: drop>(from: &signer, to: address, amount: u64, _witness: CoinType) acquires Balance {
    let from_addr = signer::address_of(from);
    assert!(from_addr != to, EEQUAL_ADDR);
    let check = withdraw<CoinType>(from_addr, amount);
    deposit<CoinType>(to, check);
  }

  fun withdraw<CoinType>(addr: address, amount: u64) : Coin<CoinType> acquires Balance {
    let balance = balance_of<CoinType>(addr);
    assert!(balance >= amount, EINSUFFICIENT_BALANCE);
    let balance_ref = &mut borrow_global_mut<Balance<CoinType>>(addr).coin.value;
    *balance_ref = balance - amount;
    Coin<CoinType> { value: amount }
  }

  fun deposit<CoinType>(addr: address, check: Coin<CoinType>) acquires Balance{
    let balance = balance_of<CoinType>(addr);
    let balance_ref = &mut borrow_global_mut<Balance<CoinType>>(addr).coin.value;
    let Coin { value } = check;
    *balance_ref = balance + value;
  }
}