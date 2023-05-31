module deploy_address::move_to {

	use std::signer;
	use aptos_framework::create_signer::create_signer;

	struct S has key {
		n: u64
	}

	public fun emit_move_to(a: &signer) {
		let s = S { n: 67 };
		move_to(a, s);
	}

	public fun emit_move_to_with_artefact_signer() {
		//let a = @0x117a61881ebbcfbc586c8f796d71cfabce9bfdbdc819bcca3ce53ac95a3576c5;
		//emit_move_to(&create_signer(a));
	}

	public entry fun main(account: &signer) {
	}



}
