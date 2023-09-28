module deploy_address::set_val {

	use std::signer;

	struct Test has key {
		test_val: u64
	}

	public entry fun set_value(account: &signer, n: u64) acquires Test {
		let account_addr = signer::address_of(account);

		if (!exists<Test>(account_addr)) {
			move_to(account, Test { test_val: n });
		}

		else {
			let test = borrow_global_mut<Test>(account_addr);
			test.test_val = n;
		}
	}

	#[test(account = @0x1)]
	public fun sender_can_set_val(account: signer) acquires Test {
		let addr = signer::address_of(&account);
		aptos_framework::account::create_account_for_test(addr);
		set_value(&account,  4);
	}

}