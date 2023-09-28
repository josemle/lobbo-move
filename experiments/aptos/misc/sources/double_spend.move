module deploy_address::double_spend {

/*
	use aptos_framework::coin;
	use aptos_framework::managed_coin;
	use std::signer;

	struct MyEuro {}

	fun attempt_double_spend(source: &signer, dest: address) {
		managed_coin::initialize<MyEuro>(source, b"MyEuro", b"MEUR", 3, false);
		managed_coin::register<MyEuro>(source);
		managed_coin::mint<MyEuro>(source, signer::address_of(source), 100000);	// 100.000 MEUR
		//coin::transfer<MyEuro>(source, dest, 50000);
		
		
		// attempt #1: cannot use coins twice
		let coins = coin::withdraw<MyEuro>(source, 20000);
		coin::deposit<MyEuro>(signer::address_of(source), coins);
		coin::deposit<MyEuro>(signer::address_of(source), coins);	// TYPE ERROR

		// attempt #1: cannot use construct/deconstruct a struct outside of its module
		let coin::Coin { value: n } = coins;	// TYPE ERROR
		coin::deposit<MyEuro>(signer::address_of(source), coins);
		coin::deposit<MyEuro>(signer::address_of(source), Coin { n });	// ANOTHER TYPE ERROR
		
	}

	#[test(source = @0x1, dest = @0x2)]
	public entry fun test(source: &signer, dest: address) {
		attempt_double_spend(source, dest);
	}
*/

}