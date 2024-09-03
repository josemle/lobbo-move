module deploy_address::references {

	//use std::signer;

struct S has key {
  x: u64,
  y: u64
}

fun freezeref_callee(n: &u64): u64 {
	*n + 1
}

fun freezeref_caller() {
	let n = 1;
	let r = &mut n;
	let m = freezeref_callee(r);	// qui subsume &mut u64 a &u64
}

fun sel(acc: address, n: u64) acquires S {
  let s = borrow_global<S>(acc);
  let ry: &u64 = &s.y;
  let rn: &mut u64 = &mut n;
  *rn = *ry + *rn
}


}