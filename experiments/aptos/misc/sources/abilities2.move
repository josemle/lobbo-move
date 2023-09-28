module deploy_address::abilities2 {


	struct S has drop {
		a: u8
	}

	public fun g(_x: S) {}

	public fun f(x: S) {
		g(x)
	}

	public fun main() {
		let x = S { a: 56 };
		f(x);
	}


}
