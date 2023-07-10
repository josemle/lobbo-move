module deploy_address::fibonacci {

	use std::signer;

	struct FibResult has key {
		fib_result: u64
	}

	struct Foo has drop {
		foo_field: u64
	}

	public fun fib(n : u64): u64 {
		if (n < 2) 1
		else fib(n - 1) + fib(n - 2)
	}

	public fun add(x: u64, y: u64): u64 {
		let foo = Foo { foo_field: 78 };
		foo.foo_field
	}

	public fun foo(x: u64): Foo {
		Foo { foo_field: x }
	}

	public entry fun move_fib(account: &signer, n: u64) acquires FibResult {
		let account_addr = signer::address_of(account);
		let fib_n = fib(n);
		if (!exists<FibResult>(account_addr)) {
			move_to(account, FibResult { fib_result: fib_n });
		}
		else {
			let fib_mut = borrow_global_mut<FibResult>(account_addr);
			fib_mut.fib_result = fib_n;
		}
	}

	fun init_module(account: &signer) acquires FibResult {
		move_fib(account, 7);
	}

}
