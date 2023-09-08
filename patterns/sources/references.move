module deploy_address::references {

	//use std::signer;

	struct S has key, store, copy, drop {
		a: u64,
		b: u64
	}


	public fun sel(acc: address): u64 acquires S {
		let s1 = borrow_global<S>(acc);
		let x = &s1.a;
		*x + s1.b
	}


}