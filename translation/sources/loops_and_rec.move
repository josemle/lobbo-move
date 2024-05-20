module deploy_address::loops_and_rec {


	public fun loop1() {
		let i = 0;
		while (i < 10) {
			i = i + 1;
		};
		loop2(10)
	}

	public fun loop2(i: u64) {
		loop {
			i = i - 1;
			if (i <= 0) break;
		};
	}

	public fun fib(n: u64): u64 {
		if (n < 2) 1
		else fib(n - 1) + fib(n - 2)
	}

	public fun loop3(i: u64, x: u64, y: u64): (u64, u64) {
		loop {
			i = i - 1;
			let a = x + i;
			let b = y - i;
			if (i > 0) {
				let (r1, r2) = loop3(i, a + b, a - b);
				x = r1;
				y = r2;
				break
			}
		};
		(x, y)
	}

}