module deploy_address::lambdas {

	use std::vector;

	public fun apply(f: |u64|u64, x: u64): u64 {
		f(x)
	}

	public fun foo(x: u64): u64 { x * 2 }

	public fun foreach<E: copy>(v: vector<E>, f: |E|) {
		let i = 0;
		while (i < vector::length(&v)) {
			f(*vector::borrow(&v, i))
		}
	}

	public fun main() {
		let b = apply(|x| x + x, 8);
		let a = apply(|x| x * 10, b);
		let _x = apply(|x| foo(x), a);
		
		let v1 = vector::empty<u64>();
		foreach(v1, |x| print(&x));
	}
	
}
