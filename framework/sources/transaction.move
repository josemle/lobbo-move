
module algomove::transaction {

	use std::string::{String, utf8};
	use algomove::opcode as op;

	const DEFAULT_FEE: u64 = 100;

	// transaction initializers (require an explicit op::itxn_submit() call afterwards)

	public fun init_header(sender: address, fee: u64, ty: String) {
		op::itxn_begin();
		op::itxn_field_Fee(fee);
		op::itxn_field_Type(ty);
		op::itxn_field_Sender(sender);
	}

	public fun init_pay(sender: address, receiver: address, amount: u64) {
		init_header(sender, DEFAULT_FEE, utf8(b"pay"));
		op::itxn_field_Receiver(receiver);
		op::itxn_field_Amount(amount);
	}

	public fun init_asset_config(sender: address, total: u64, decimals: u64, default_frozen: bool,  name: String, short_name: String) {		
		init_header(sender, DEFAULT_FEE, utf8(b"acfg"));
		op::itxn_field_Total(total);
		op::itxn_field_Decimals(decimals);
		op::itxn_field_DefaultFrozen(default_frozen);
		op::itxn_field_Name(name);
		op::itxn_field_UnitName(short_name);
	}

	public fun init_asset_transfer(sender: address, id: u64, receiver: address) {
		init_header(sender, DEFAULT_FEE, utf8(b"axfer"));
		op::itxn_field_XferAsset(id);
		op::itxn_field_AssetReceiver(receiver);
	}

	// shortcuts to common transactions

	public fun pay(sender: address, receiver: address, amount: u64) {
		init_pay(sender, receiver, amount);
		op::itxn_submit();
	}

	public fun asset_config(sender: address, total: u64, decimals: u64, default_frozen: bool, name: String, short_name: String) {
		init_asset_config(sender, total, decimals, default_frozen, name, short_name);
		op::itxn_submit();
	}

	public fun asset_transfer(sender: address, id: u64, amount: u64, receiver: address) {
		init_asset_transfer(sender, id, receiver);
		op::itxn_field_AssetSender(@0x0);	// address 0 when normal transfer between senderounts (see Algorand doc) 
		op::itxn_field_AssetAmount(amount);
		op::itxn_submit();
	}

	public fun asset_optin(sender: address, id: u64, receiver: address) {
		init_asset_transfer(sender, id, receiver);
		op::itxn_submit();
	}

	// other stuff

	public fun retrieve_asset_id<AssetType>(): u64 {
		let name = name_of<AssetType>();
		let len = op::txn_NumAssets();
		let i = 0;
		while (i < len) {
			let id = op::txnas_Assets(i);
			let s = op::asset_params_get_AssetName(id);
			if (s == name) return id;
			i = i + 1;
		};
		assert!(false, 0);
		0
	}

	// natives
	//

	native public fun name_of<T>(): String;
	native public fun address_of_signer(s: &signer) : address;
	native public fun bytes_of_address(a: address): vector<u8>;




}