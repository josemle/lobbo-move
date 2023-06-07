module deploy_address::struct_has_key {

	use std::signer;

	struct S has key {
		f: u64,
		g: bool
	}

	public entry fun set(account: &signer) {
		let n = 8;
		let m = true;
		move_to(account, S { f: n, g: m });
	}

}