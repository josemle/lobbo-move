module move4algo_framework::sample_app1 {

	use move4algo_framework::opcode;
	use move4algo_framework::asset;
	use std::string;

	struct LocalStorageTest has key {
		n: u64,
		m: bool
	}

	public fun test_local_storage() {
		let addr = @0x1;
		let key: vector<u8> = b"LocalStorageTest";
		let s = LocalStorageTest { n: 16, m: true };
		opcode::app_local_put_struct(addr, key, s);

		let s2 = opcode::app_local_get_struct<LocalStorageTest>(addr, key);
		s2.n = s2.n + 1;
		opcode::app_local_put_struct(addr, key, s2);
	}

	struct Euro {}

	public fun test_asset_transfer() {
		let asset = asset::create<Euro>(10000, 2, false, string::utf8(b"Euro"), string::utf8(b"EUR"));
		let asset2 = asset::transfer(@0x1, asset, 100);
		let asset3 = asset::transfer(@0x1, asset2, 500);
		let id = asset::release(asset3);
		
		// riacquisisco il controllo degli asset
		let asset4 = asset::acquire(id);
		let asset5 = asset::transfer(@0x1, asset4, 100);
		let _id = asset::release(asset5);
	}

	public fun test_asset_transfer2() {
		let asset = asset::create<Euro>(10000, 2, false, string::utf8(b"Euro"), string::utf8(b"EUR"));
		asset::transfer2(@0x1, &mut asset, 100);
		asset::transfer2(@0x1, &mut asset, 500);
		let _id = asset::release(asset);
	}


}