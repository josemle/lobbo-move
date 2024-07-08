/// This module defines a minimal and generic Coin and Balance.
module deploy_address::borrows_and_move_from {
  	use std::signer;

	struct S has key, drop { 
		x: u64
	}

	struct T has key, drop { 
		x: u64
	}

	public fun f(acc: &signer) acquires S, T {
		let a = signer::address_of(acc);
		let s1 = borrow_global_mut<S>(@0x1);
		let s2 = move_from<T>(a);
		*s1 = S { x: 1 };
		move_to(acc, s2);
	}

  	public entry fun main(acc: &signer) acquires S, T {
		f(acc);
  	}


}