module deploy_address::algorand_layer_caller {

	use deploy_address::algorand_layer;

	struct Caz has key {
		n: u64,
		m: bool
	}

	public entry fun main() {
		let addr = @0x1;
		let key: vector<u8> = b"Caz";
		let s = Caz { n: 16, m: true };
		algorand_layer::app_local_put_struct(addr, key, s)
	}

}