module deploy_address::algorand_layer {

	use std::string::{String, utf8};


	native public fun itxn_begin();
	native public fun itxn_submit();
	native public fun itxn_field_fee(x: u64);
	native public fun itxn_field_type(x: String);
	native public fun itxn_field_sender(x: address);
	native public fun itxn_field_receiver(x: address);
	native public fun itxn_field_amount(x: u64);

	public fun itxn_header(fee: u64, ty: String, snd: address, rcv: address) {
		itxn_field_fee(1000);
		itxn_field_type(ty);
		itxn_field_sender(snd);
		itxn_field_receiver(rcv);
	}

	public fun itxn_pay(snd: address, rcv: address, amount: u64) {
		itxn_begin();
		itxn_header(1000, utf8(b"pay"), snd, rcv);
		itxn_field_amount(amount);
		itxn_submit();
	}

	native public fun app_local_put_struct<T: key>(addr: address, k: vector<u8>, data: T);
	native public fun app_local_put_bytes(addr: address, k: vector<u8>, data: vector<u8>);
	native public fun app_local_put_u64(addr: address, k: vector<u8>, data: u64);
	
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