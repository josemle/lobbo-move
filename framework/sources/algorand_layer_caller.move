module deploy_address::algorand_layer_caller {

	use deploy_address::algorand_layer;
	use std::signer;
	use std::string;

	struct Caz has key {
		n: u64,
		m: bool
	}

	public fun test_local_storage() {
		let addr = @0x1;
		let key: vector<u8> = b"Caz";
		let s = Caz { n: 16, m: true };
		algorand_layer::app_local_put_struct(addr, key, s);

		let s2 = algorand_layer::app_local_get_struct<Caz>(addr, key);
		s2.n = s2.n + 1;
		algorand_layer::app_local_put_struct(addr, key, s2);
	}

	public fun test_asset(account: &signer) {
		let addr = signer::address_of(account);
		algorand_layer::init_config_asset(addr, 10000, 2, false);
		algorand_layer::itxn_field_config_asset_name(string::utf8(b"Euro"));
		algorand_layer::itxn_field_config_asset_unit_name(string::utf8(b"EUR"));
		algorand_layer::itxn_submit();
	}

	public entry fun main(account: &signer) {
		test_asset(account)
	}

}