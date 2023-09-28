module deploy_address::framework_call {

	use aptos_framework::coin;
	use aptos_framework::aggregator;
	use aptos_framework::aggregator_factory;
	use aptos_framework::object;

	struct MyRes has key {
		n: u64
	}

	struct MyCoinType {
	}

	public fun g(a: address) {
		let _ = exists<MyRes>(a);
		let _ = object::address_to_object<MyRes>(a);
		//let _ = borrow_global<coin::SupplyConfig>(a);
	}


	public fun f(account: &signer) {
		let agg = aggregator_factory::create_aggregator(account, 100);
		aggregator::add(&mut agg, 10);
		aggregator::destroy(agg);
	}

	public entry fun main(account: &signer) {
		coin::register<coin::Coin<MyCoinType>>(account);
		f(account);
	}



}
