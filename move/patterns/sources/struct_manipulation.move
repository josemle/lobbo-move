module deploy_address::struct_manipulation {

	struct Simple has drop {
		f: u64,
		g: bool
	}

	struct Nested1 has drop {
		a: Simple,
		b: u64
	}

	struct Nested2<T: store> {
		a: T,
		b: u64
	}

	struct Nested3 {
		a: Simple,
		b: u64,
		c: Simple
	}


	public entry fun manipulate1() {
		let n = 5;
		let s1 = Simple { f: n, g: false };
		let s2 = Nested1 { a: s1, b: 78 };
		let n1 = s2.a.f + s2.b;
    s2.a.f = n1;
	}

}