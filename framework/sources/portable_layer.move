module deploy_address::portable_layer {

	use std::signer;
	use deploy_address::algorand_layer;

	struct Coin<phantom CoinType> {
		value: u64
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