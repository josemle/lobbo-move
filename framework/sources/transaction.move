
module move4algo_framework::transaction {

	use std::string::{String, utf8};
	use std::option::{Self};
	use move4algo_framework::opcode as op;

	const DEFAULT_FEE: u64 = 1000;

	// transaction initializers
	//   - require an explicit submit() call afterwards
	//   - users can add fields using proper opcodes

	public fun init_header(fee: u64, ty: String, sender: address) {
		op::itxn_begin();
		op::itxn_field_Fee(fee);
		op::itxn_field_Type(ty);
		op::itxn_field_Sender(sender);
	}

	public fun init_pay(sender: address, receiver: address, amount: u64) {
		init_header(DEFAULT_FEE, utf8(b"pay"), sender);
		op::itxn_field_Receiver(receiver);
		op::itxn_field_Amount(amount);
	}

	public fun init_asset_config(sender: address, total: u64, decimals: u64, default_frozen: bool) {
		init_header(DEFAULT_FEE, utf8(b"acfg"), sender);
		op::itxn_field_Total(total);
		op::itxn_field_Decimals(decimals);
		op::itxn_field_DefaultFrozen(default_frozen);
	}

	public fun init_asset_transfer(id: u64, sender: address, receiver: address) {
		init_header(DEFAULT_FEE, utf8(b"axfer"), sender);
		op::itxn_field_XferAsset(id);
		op::itxn_field_AssetReceiver(receiver);
	}


	// shortcuts to common transactions
	//   - perform an init and then call submit()
	//   - users cannot add fields

	public fun pay(sender: address, receiver: address, amount: u64) {
		init_pay(sender, receiver, amount);
		submit();
	}

	public fun asset_config(sender: address, total: u64, decimals: u64, default_frozen: bool) {
		init_asset_config(sender, total, decimals, default_frozen);
		submit();
	}

	public fun asset_transfer(id: u64, amount: u64, sender: address, receiver: address) {
		init_asset_transfer(id, sender, receiver);
		op::itxn_field_AssetSender(@0x0);	// address 0 when normal transfer between accounts (see Algorand doc) 
		op::itxn_field_AssetAmount(amount);
		submit();
	}

	public fun asset_optin(id: u64, sender: address, receiver: address) {
		init_asset_transfer(id, sender, receiver);
		submit();
	}


	// stubs

	public fun submit() {
		op::itxn_submit();
	}

	public fun get_sender(): address {
		op::txn_Sender()
	}

	public fun get_sender_as_signer(): signer {
		create_signer(get_sender())
	}

	// TODO: occhio a queste due. 
	// Al momento sono native perche' il transpiler le traduce in modo che non facciano nulla.
	// Noi infatti non abbiamo signer in Algorand, ma solo address. 
	// Mentre il tipo signer e' una astrazione di Move che noi supportiamo solamente perche' serve alla move_to().
	// Ma trattiamo i signer esattamente come fossero semplici address: insomma in Algorand &signer = address
	native fun address_of_signer(s: &signer) : address;
	native fun create_signer(addr: address): signer;

}