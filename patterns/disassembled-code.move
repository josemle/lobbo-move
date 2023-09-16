// Move bytecode v6
module f77304f0b8426e09de5799104bfbc0a0efbbdaef95b5c172fb93522a19d5ee9e.references {
struct S has key {
	a: u64,
	b: u64
}

public sel(Arg0: address, Arg1: u64): u64 {
B0:
	0: MoveLoc[0](Arg0: address)
	1: ImmBorrowGlobal[0](S)
	2: ImmBorrowField[0](S.b: u64)
	3: StLoc[2](loc0: &u64)
	4: ImmBorrowLoc[1](Arg1: u64)
	5: StLoc[3](loc1: &u64)
	6: MoveLoc[2](loc0: &u64)
	7: ReadRef
	8: MoveLoc[3](loc1: &u64)
	9: ReadRef
	10: Add
	11: Ret
}
}