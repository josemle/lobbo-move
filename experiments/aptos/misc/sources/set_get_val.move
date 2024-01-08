module deploy_address::set_get_val {
	
  	use std::signer;
	
	struct S has key {
		val: u64
	}

	public fun set(acc: &signer, n: u64) {
		let s = S { val: n };		
		move_to(acc, s);
	}

	public fun get(acc: address): u64 acquires S {
		let s = borrow_global<S>(acc);
		s.val
	}

	public fun update(acc: &signer, new_val: u64) acquires S {
		let acc_address = signer::address_of(acc);
		let s = borrow_global_mut<S>(acc_address);
		s.val = new_val;
	}

	#[test(account = @0x1)]
	public fun sender_can_set_val(account: signer) {
		let addr = signer::address_of(&account);
		aptos_framework::account::create_account_for_test(addr);
		set(&account,  4);
	}

}