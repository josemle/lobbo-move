module deploy_address::struct_has_key {

	//use std::signer;

	struct Simple has key, store, copy, drop {
		f: u64,
		g: bool
	}

	struct Nested1 has key, store {
		a: Simple,
		b: u64
	}

	struct Nested2<T: store> has key {
		a: T,
		b: u64
	}

	struct Nested3 has key, store {
		a: Simple,
		b: u64,
		c: Simple
	}


	public fun moveto1(account: signer, n: u64) {
		let m = true;
		move_to(&account, Simple { f: n + 39, g: m });
	}


	public fun moveto2(account: &signer) {
		let n = 5;
		let s1 = Simple { f: n, g: false };
		let s2 = Nested1 { a: s1, b: 78 };
		move_to(account, s2);
		move_to(account, s3);
	}

	
	public fun moveto3(account: &signer) {
		let n = 5;
		let s1 = Simple { f: n, g: false };
		let s2 = Nested1 { a: s1, b: 34 };
		let s3 = Nested2 { a: s2, b: 9099 };
		move_to(account, s3);
	}

	public fun moveto4(account: &signer) {
		let n = 5;
		let s1 = Simple { f: n, g: false };
		let s2 = Nested3 { a: s1, b: 88, c: s1 };
		//let addr = signer::address_of(account);
		//let addr2 = *signer::borrow_address(account);
		move_to(account, s2);
	}

	public fun borrow1(account: address ): u64 acquires Simple {
		let s1 = borrow_global_mut<Simple>(account);
		s1.f = s1.f + 2;
		s1.f
	}

	public fun borrow2(account: address ): u64 acquires Simple {
		let s1 = borrow_global_mut<Simple>(account);
		// TODO: provare a fare una borrow con un tipo definito in un altro modulo
		let u = &mut s1.f;
		*u = *u;
		*u = *u + 2;
		let z = u;
		*z
	}

	public fun borrow3(account: address ): u64 acquires Nested3 {
		let s1 = borrow_global<Nested3>(account);
		let s2: &Simple = &s1.a;		
		let n = s1.b;
		let m: &u64 = &n;
		(*s2).f + *m
	}

	public fun borrow4(account: address ) acquires Simple {
		let s1 = borrow_global_mut<Simple>(account);
		*s1 = Simple { f: 1, g: true };
	}

	public fun borrow5(account: address ): bool acquires Simple, Nested1, Nested3 {
		let s1 = borrow_global_mut<Simple>(account);
		let s2 = borrow_global_mut<Nested1>(account);
		let s3 = borrow_global_mut<Nested3>(account);
		let n = s1.f + s2.b + s3.b;
		if (n < 100) true else false
	}

	// TODO: provare anche la move_from 

	public entry fun main(account: &signer) {
		moveto2(account);
		moveto2(account);
	}

}