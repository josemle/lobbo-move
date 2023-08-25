module move4algo_framework::algos {

	use move4algo_framework::opcode;
	use move4algo_framework::transaction;

	struct Algos has store {
		from: address,
		amount: u64
	}

	public fun withdraw(from: address, amount: u64): Algos {
		Algos { from, amount }
	}

	public fun deposit(to: address, algos: Algos) {
		let Algos { from, amount } = algos;
		transfer(from, to, amount)
	}

	public fun transfer(
        from: address,
        to: address,
        amount: u64
	) {
		// TODO fare qualche check a runtime?
		transaction::init_pay(from, to, amount);
		opcode::itxn_submit();
    }



}