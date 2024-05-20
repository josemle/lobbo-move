module deploy_address::references {

	//use std::signer;

	struct S has key {
		a: u64,
		b: u64
	}


	public fun sel(acc: address, x: u64): u64 acquires S {
		let s: &S = borrow_global<S>(acc);
		let r: &u64 = &s.b;
		let rx: &u64 = &x;
		*r + *rx
	}


}