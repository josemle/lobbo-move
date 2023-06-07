module deploy_address::struct_has_key {

	struct Simple has key, store {
		f: u64,
		g: bool
	}

	struct Nested1 has key, store {
		a: Simple,
		b: u64
	}

	struct Nested2<T: store> has key {
		a: T,
		b: u64
	}

	public entry fun moveto1(account: &signer) {
		let n = 8;
		let m = true;
		move_to(account, Simple { f: n, g: m });
	}


	public entry fun moveto2(account: &signer) {
		let n = 5;
		let s1 = Simple { f: n, g: false };
		let s2 = Nested1 { a: s1, b: 78 };
		move_to(account, s2);
	}

	
	public entry fun moveto3(account: &signer) {
		let n = 5;
		let s1 = Simple { f: n, g: false };
		let s2 = Nested1 { a: s1, b: 34 };
		let s3 = Nested2 { a: s2, b: 9099 };
		move_to(account, s3);
	}

}