// Move bytecode v6
module 123.simple {
struct Simple has key {
	a: u64,
	b: bool
}

public f(Arg0: signer, Arg1: u64) {
B0:
	0: MoveLoc[1](Arg1: u64)
	1: LdU64(7)
	2: Add
	3: LdTrue
	4: Pack[0](Simple)
	5: StLoc[2](loc0: Simple)
	6: ImmBorrowLoc[0](Arg0: signer)
	7: MoveLoc[2](loc0: Simple)
	8: MoveTo[0](Simple)
	9: Ret
}
public g(Arg0: signer) {
B0:
	0: MoveLoc[0](Arg0: signer)
	1: LdU64(58)
	2: Call h(u64): u64
	3: Call f(signer, u64)
	4: Ret
}
public h(Arg0: u64): u64 {
B0:
	0: MoveLoc[0](Arg0: u64)
	1: LdU64(18)
	2: Add
	3: Ret
}
}