module move4algo_framework::coin {

	use std::signer;
	use move4algo_framework::opcode;
	use move4algo_framework::transaction;

	struct Coin<phantom CoinType> has store {
		value: u64
	}

	public fun transfer(
        from: &signer,
        to: address,
        amount: u64
	) {
		// TODO fare qualche check a runtime?
		transaction::init_pay(signer::address_of(from), to, amount);
		opcode::itxn_submit();
    }



}