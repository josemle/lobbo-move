module deploy_address::set_get_val {

	struct S has key {
		f: u64
	}

	public fun set(acc: &signer, n: u64) {
		let s = S { f: n };		
		move_to(acc, s);
	}

	public fun get(acc: address): u64 acquires S {
		let s = borrow_global_mut<S>(acc);
		s.f
	}

	#[test(account = @0x1)]
	public fun sender_can_set_val(account: signer) acquires S {
		let addr = signer::address_of(&account);
		aptos_framework::account::create_account_for_test(addr);
		set_val(&account,  4);
	}

}