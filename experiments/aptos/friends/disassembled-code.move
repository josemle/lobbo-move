// Move bytecode v6
module 123.module_a {
struct A {
	val: u64
}
struct C has key {
	val: vector<u64>
}

public get(Arg0: &A): u64 {
B0:
	0: MoveLoc[0](Arg0: &A)
	1: ImmBorrowField[0](A.val: u64)
	2: ReadRef
	3: Ret
}
public get_val(): u64 {
B0:
	0: LdU64(8)
	1: Ret
}
public move_vector(Arg0: &signer, Arg1: C) {
B0:
	0: MoveLoc[0](Arg0: &signer)
	1: MoveLoc[1](Arg1: C)
	2: MoveTo[1](C)
	3: Ret
}
public set_A(Arg0: &mut A, Arg1: u64) {
B0:
	0: MoveLoc[1](Arg1: u64)
	1: MoveLoc[0](Arg0: &mut A)
	2: MutBorrowField[0](A.val: u64)
	3: WriteRef
	4: Ret
}
}