module deploy_address::abilities2 {

	use std::signer;
	use deploy_address::abilities;

	struct S has drop {
		a: u8
	}

	public fun g(x: S) {}

	public fun f(x: S) {
		g(x)
	}

	public fun main() {
		let x = S { a: 56 };
		f(x);
	}


}
