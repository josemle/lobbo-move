module deploy_address::example {

	struct S has key {
		int_val: u64
	}

	public entry fun move_to_example(account: &signer, n: u64) {
		move_to(account, S { int_val: n });
	}
}