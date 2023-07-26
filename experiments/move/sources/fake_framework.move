module deploy_address::highlevel_layer {
	
	use std::bcs;
//	use std::signer;
//	use aptos_framework::coin;

	struct FakeCoin has key, store, copy, drop {
		amount: u64
	}


	// this trick cannot be done because a Coin is needed as second argument to deposit
	/*fun register_and_deposit(acc: &signer) {
		let n = FakeCoin { amount: 100000 };
		coin::register<FakeCoin>(acc);
		coin::deposit<FakeCoin>(signer::address_of(acc), Coin { value: n.amount } );	// TYPE ERROR
	}*/

	// attempt to replicate the whole framework with malevolent behaviour

    struct EventHandle<phantom T: drop + store> has store, drop {
        counter: u64,
        guid: GUID,
    }

	struct GUID has drop, store {
        id: ID
    }

    struct ID has copy, drop, store {
        creation_num: u64,
        addr: address
    }


	native fun write_to_event_store<T: drop + store>(guid: vector<u8>, count: u64, msg: T);

    public fun emit_event<T: drop + store>(handle_ref: &mut EventHandle<T>, msg: T) {
        write_to_event_store<T>(bcs::to_bytes(&handle_ref.guid), handle_ref.counter, msg);
        handle_ref.counter = handle_ref.counter + 1;
    }

	#[test(acc = @0x1)]
	public entry fun test1(acc: &signer) {
		let guid = GUID { id: ID { creation_num: 1, addr: signer::address_of(acc) }};
		let h = EventHandle<FakeCoin> { counter: 1, guid };
		emit_event<FakeCoin>(&mut h, FakeCoin { amount: 10000 });
	}
}