module deploy_address::borrow_field_order {

	struct A has drop, key, store, copy {
		b: bool,
		u: u64
	}
	
	struct B has drop, key, store {
		b: bool,
		u: u64
	}

	struct C has drop, key {
		x: A,
		y: B
	}

  	public fun borrow_manipulation(account: address): bool acquires A, B, C{
		let a = borrow_global_mut<A>(account);
		let b = borrow_global_mut<B>(account);
		let c = borrow_global_mut<C>(account);

		if (c.x.u + c.y.u == a.u + b.u ) true else false
		//if (a.u + b.u == c.x.u + c.y.u) true else false
	}

	public entry fun manipulation() {
		let n = 5;

		let m: &u64 = &n;

    	let a = A { u: n, b: false };
		let b = B { u: 18, b: true };
				
    	let c = C { x: a, y: b };

    	let a_b = A { u: c.x.u + c.y.u, b: c.x.b && c.y.b };

		let n1 = c.y.u * a_b.u + c.x.u;
	}

	public fun read_ref1(r: &u64): u64 {
		*r + 1
	}

	public fun read_ref2(r: &A): u64 {
		r.u
	}


	public fun read_ref_caller(a: address) acquires A {
		let a1 = A { b: true, u: 78 };
		let m = borrow_global_mut<A>(a);
		read_ref1(&a1.u);
		let n = 56;
		read_ref1(&n);
		let b = B { u: 18, b: true };
		let c = C { x: a1, y : b };
		read_ref1(&c.x.u);

		read_ref2(&a1);
		read_ref2(m);
	}

}