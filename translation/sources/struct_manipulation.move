module deploy_address::struct_manipulation {

	struct A has drop, key, store {
		a: bool,
		b: u64
	}
	
	struct B has drop, key, store {
		a: bool,
		b: u64
	}

	struct Nested has drop, key {
		a: A,
		b: B
	}

	struct Nested1 has drop {
		a: Simple,
		b: u64
	}

	struct Simple has drop {
		f: u64,
		g: bool
	}

	public entry fun manipulate1() {
		let n = 5;
		let s1 = Simple { f: n, g: false };
		let s2 = Nested1 { a: s1, b: 78 };
		let n1 = s2.a.f + s2.b;
    s2.a.f = n1;
	}

	public fun manipulate2(): u64 {
		let n1 = 18;
		let b1 = true;

		let s1 = A { a:b1, b: n1};

		let n2 = 77;
		let b2 = false;
		
		let s2 = B { a:b2, b: n2};

		let s3 = Nested { a: s1, b: s2};

		let res = s3.a.b + s3.b.b;
		res
	}

	public fun borrow_manipulation(account: address): bool acquires A, B, Nested{
		let s1 = borrow_global_mut<A>(account);
		let s2 = borrow_global_mut<B>(account);
		let s3 = borrow_global_mut<Nested>(account);

		if (s1.b + s2.b == s3.a.b + s3.b.b ) true else false

	}

}