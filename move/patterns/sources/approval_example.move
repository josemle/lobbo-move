module deploy_address::approval_example {

    // queste native e costanti sono un piccolo pezzo del nostro framework
    native public fun txn(field: u64): vector<u8>;
    native public fun string_of_signer(s: &signer): vector<u8>;

    const Sender: u64 = 0;
    const Type: u64 = 4;
    const Receiver: u64 = 7;
    ////

    // questo e' il main scritto dal programmatore che vuole usare Algo4Move per scrivere
    // un approval in Move
    public fun approval(account: &signer): bool {
        if (txn(Type) != b"pay") false
        else if (txn(Sender) != string_of_signer(account)) false
        else true
    }

    // questo lo generiamo noi ed e' la vera entry
	public entry fun main(account: &signer) {
        assert!(approval(account), 1)
	}

}