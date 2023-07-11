module deploy_address::sample_trans1 {

	fun g(x: u64, y: u64): u64 {
		x * y
	}

	fun f(x: u64): u64 {
		g(x + 4, 8 + 10)
	}

	public entry fun main() {
		let x = 1;
		f(x + 3);
		f(x + 2);
		f(x + 1);
	}


}
