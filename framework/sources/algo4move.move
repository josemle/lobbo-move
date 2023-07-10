module deploy_address::algo4move {


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