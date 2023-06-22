module deploy_address::approval_example {

    use move2algo_framework::txn;

    // queste costanti andrebbero in un modulo del move2algo framework
    const Sender = 0;
    const Type = 4;
    const Receiver = 7;

    // questo è il main scritto dal programmatore che vuole usare Algo4Move per scrivere
    // un approval in Move
    public fun approval(account: &signer): bool {
        if (txn(Type) != "pay") false;
        if (txn(Sender) != account) false;
        true
    }

    // questo lo generiamo noi ed è la vera entry
	public entry fun main(account: &signer): bool {
        assert (approval(account))
	}

}