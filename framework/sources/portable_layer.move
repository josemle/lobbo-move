module deploy_address::portable_layer {

	use std::signer;
	use deploy_address::algorand_layer;

	struct Coin<phantom CoinType> has store {
		value: u64
	}

	struct Asset<phantom AssetType> has key {
		id: u64
	}

	public fun create_asset<AssetType>(
		snd: address,
		total: u64, 
		decimals: u64, 
		default_frozen: bool)
		: Asset<AssetType> 
	{
		algorand_layer::init_config_asset(snd, total, decimals, default_frozen);
		algorand_layer::itxn_submit();
		Asset<AssetType> { id: algorand_layer::txn_created_asset_id() }
	}

	struct Balance<phantom CoinType> has key {
    coin: Coin<CoinType>
  }

	public fun transfer<CoinType>(
        from: &signer,
        to: address,
        amount: u64,
    ) {
		// TODO fare qualche check a runtime?
		algorand_layer::init_pay(signer::address_of(from), to, amount);
		algorand_layer::itxn_submit();
    }

	#[test_only]
	use aptos_framework::coin;

	#[test]
	public fun test(account: &signer) {
		coin::deposit(signer::address_of(account), coin::Coin<u64> { value: 200000 })
	}



}