module deploy_address::borrow_field_order {

	struct A has drop, key, store {
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
		
    let a = A { u: n, b: false };
		let b = B { u: 18, b: true };
		
    let c = C { x: a, y: b };

    let a_b = A { u: c.x.u + c.y.u, b: c.x.b && c.y.b };

		let n1 = c.y.u * a_b.u + c.x.u;
	}

}