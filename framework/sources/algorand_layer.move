module deploy_address::algorand_layer {

	use std::string::{String, utf8};

	const DEFAULT_FEE: u64 = 1000;

	// low level transactions

	native public fun txn_sender(): address;
	native public fun txn_created_asset_id(): u64;

	native public fun itxn_begin();
	native public fun itxn_submit();
	// header fields
	native public fun itxn_field_fee(x: u64);
	native public fun itxn_field_type(x: String);
	native public fun itxn_field_sender(x: address);
	native public fun itxn_field_receiver(x: address);
	native public fun itxn_field_genesis_id(x: String);	// optional
	native public fun itxn_field_amount(x: u64);
	// asset config and params
	native public fun itxn_field_config_asset_total(x: u64);
	native public fun itxn_field_config_asset_decimals(x: u64);
	native public fun itxn_field_config_asset_default_frozen(x: bool);
	native public fun itxn_field_config_asset_unit_name(x: String);	// optional
	native public fun itxn_field_config_asset_name(x: String);	// optional
	

	public fun itxn_header(fee: u64, ty: String, snd: address) {
		itxn_field_fee(fee);
		itxn_field_type(ty);
		itxn_field_sender(snd);
	}

	// high level transactions

	public fun init_pay(snd: address, rcv: address, amount: u64) {
		itxn_begin();	// facciamo la begin e non la submit, ma non e' chiarissimo per il caller
		itxn_header(DEFAULT_FEE, utf8(b"pay"), snd);
		itxn_field_receiver(rcv);
		itxn_field_amount(amount);
	}

	public fun init_config_asset(snd: address, total: u64, decimals: u64, default_frozen: bool) {
		itxn_begin();
		itxn_header(DEFAULT_FEE, utf8(b"acfg"), snd);
		itxn_field_config_asset_total(total);
		itxn_field_config_asset_decimals(decimals);
		itxn_field_config_asset_default_frozen(default_frozen);
	}

	public fun get_sender(): address {
		txn_sender()
	}

	// app local put/get

	native public fun app_local_put_struct<T: key>(addr: address, k: vector<u8>, data: T);
	native public fun app_local_put_bytes(addr: address, k: vector<u8>, data: vector<u8>);
	native public fun app_local_put_u64(addr: address, k: vector<u8>, data: u64);

	native public fun app_local_get_struct<T: key>(addr: address, k: vector<u8>): T;
	native public fun app_local_get_bytes(addr: address, k: vector<u8>): vector<u8>;
	native public fun app_local_get_u64(addr: address, k: vector<u8>): u64;

	// TENTATIVE API: higher level access to Algorand local storage
	// brutta, non serve quasi a niente

	/*struct Handle<T: key> has drop, copy {
		addr: address,
		key: vector<u8>,
	}

	public fun borrow<T: key>(addr: address, k: vector<u8>): (&mut T, Handle<T>) {
		let r = app_local_get_struct<T>(addr, k);
		(r, Handle { addr, key: k })
	}

	public fun update<T: key>(data: &mut T, h: Handle<T>) {
		app_local_put_struct(h.addr, h.key, *data)
	}*/

	// serialization

	public fun itob_bool(data: bool): vector<u8> {
		if (data) itob(1)
		else itob(0)
	}
	native public fun itob(data: u64): vector<u8>;

	public fun btoi_bool(data: vector<u8>): bool {
		btoi(data) == 1
	}
	native public fun btoi(data: vector<u8>): u64;

}