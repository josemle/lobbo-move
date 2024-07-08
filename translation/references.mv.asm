// Move bytecode v6
module aaaa.references {
struct S has key {
	x: u64,
	y: u64
}

freezeref_callee(Arg0: &u64): u64 /* def_idx: 0 */ {
B0:
	0: MoveLoc[0](Arg0: &u64)
	1: ReadRef
	2: LdU64(1)
	3: Add
	4: Ret
}
freezeref_caller() /* def_idx: 1 */ {
L0:	loc0: u64
B0:
	0: LdU64(1)
	1: StLoc[0](loc0: u64)
	2: MutBorrowLoc[0](loc0: u64)
	3: FreezeRef
	4: Call freezeref_callee(&u64): u64
	5: Pop
	6: Ret
}
sel(Arg0: address, Arg1: u64) /* def_idx: 2 */ {
L2:	loc0: &mut u64
L3:	loc1: &u64
B0:
	0: MoveLoc[0](Arg0: address)
	1: ImmBorrowGlobal[0](S)
	2: ImmBorrowField[0](S.y: u64)
	3: StLoc[3](loc1: &u64)
	4: MutBorrowLoc[1](Arg1: u64)
	5: StLoc[2](loc0: &mut u64)
	6: MoveLoc[3](loc1: &u64)
	7: ReadRef
	8: CopyLoc[2](loc0: &mut u64)
	9: ReadRef
	10: Add
	11: MoveLoc[2](loc0: &mut u64)
	12: WriteRef
	13: Ret
}
}