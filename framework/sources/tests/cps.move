module algomove::cps {

	use algomove::opcode;
	use algomove::asset;
	use algomove::transaction;
	use std::string;

	struct LocalStorageTest has key {
		n: u64,
		m: bool
	}

	public fun test_local_storage() {
		let addr = @0x1;
		let key: vector<u8> = b"LocalStorageTest";
		let s = LocalStorageTest { n: 16, m: true };
		opcode::app_local_put(addr, key, s);

		let s2 = opcode::app_local_get<LocalStorageTest>(addr, key);
		s2.n = s2.n + 1;
		opcode::app_local_put(addr, key, s2);
	}

	struct Euro {}

	public fun test_asset_transfer() {
		let sender = transaction::get_sender();
		let asset = asset::create<Euro>(sender, 10000, 2, false, string::utf8(b"Euro"), string::utf8(b"EUR"));
		let asset2 = asset::transfer(@0x1, asset, 100);
		let asset3 = asset::transfer(@0x1, asset2, 500);
		let id = asset::release(asset3);
		
		// riacquisisco il controllo degli asset
		let asset4 = asset::acquire(id);
		let asset5 = asset::transfer(@0x1, asset4, 100);
		let _id = asset::release(asset5);
	}


}