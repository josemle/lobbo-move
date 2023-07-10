module deploy_address::references {

	struct Resource has key {
		foo: u64
	}

	fun f(x: &u64): u64 {
		*x + 4
	}

    fun g(x: &mut u64) {
		*x = *x + 4
	}

	public entry fun imm_call() {
		let _x = 1;
		_x = f(&_x);
	}

  	public entry fun mut_call() {
		let x = 1;
		g(&mut x);
	}

	public entry fun global_mut_call(addr :address) acquires Resource {
		let res = borrow_global<Resource>(addr);
		let _foo = res.foo;
	}


}