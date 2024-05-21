module deploy_address::double_address {


	struct S has key {
		a: u64
	}

	public entry fun g(a1: address, a2: address) acquires S  {
        let s_ref = borrow_global_mut<S>(a1);
        let s_ref2 = borrow_global_mut<S>(a2);
        //let s = move_from<S>(a2);
        //let S { a } = s;
        let a1 = s_ref.a;
        let a2 = s_ref2.a;
        let c = a1 + a2;
    }

    public entry fun register(acc: &signer) {
        let s = S { a: 0 };
        move_to(acc, s);
    }
}