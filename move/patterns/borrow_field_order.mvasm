// Move bytecode v6
module 221e04878647f87928e83d1a0f0ec826a40364527027dca5a940d6ae95e8fdf1.borrow_field_order {
struct A has drop, store, key {
	b: bool,
	u: u64
}
struct B has drop, store, key {
	b: bool,
	u: u64
}
struct C has drop, key {
	x: A,
	y: B
}

public borrow_manipulation(Arg0: address): bool {
L0:	loc1: &mut A
L1:	loc2: &mut B
L2:	loc3: &mut C
B0:
	0: CopyLoc[0](Arg0: address)
	1: MutBorrowGlobal[0](A)
	2: StLoc[2](loc1: &mut A)
	3: CopyLoc[0](Arg0: address)
	4: MutBorrowGlobal[1](B)
	5: StLoc[3](loc2: &mut B)
	6: MoveLoc[0](Arg0: address)
	7: MutBorrowGlobal[2](C)
	8: StLoc[4](loc3: &mut C)
	9: MoveLoc[2](loc1: &mut A)
	10: ImmBorrowField[0](A.u: u64)
	11: ReadRef
	12: MoveLoc[3](loc2: &mut B)
	13: ImmBorrowField[1](B.u: u64)
	14: ReadRef
	15: Add
	16: CopyLoc[4](loc3: &mut C)
	17: ImmBorrowField[2](C.x: A)
	18: ImmBorrowField[0](A.u: u64)
	19: ReadRef
	20: MoveLoc[4](loc3: &mut C)
	21: ImmBorrowField[3](C.y: B)
	22: ImmBorrowField[1](B.u: u64)
	23: ReadRef
	24: Add
	25: Eq
	26: BrFalse(30)
B1:
	27: LdTrue
	28: StLoc[1](loc0: bool)
	29: Branch(32)
B2:
	30: LdFalse
	31: StLoc[1](loc0: bool)
B3:
	32: MoveLoc[1](loc0: bool)
	33: Ret
}
entry public manipulation() {
L0:	loc0: u64
L1:	loc1: bool
L2:	loc2: A
L3:	loc3: C
B0:
	0: LdFalse
	1: LdU64(5)
	2: Pack[0](A)
	3: LdTrue
	4: LdU64(18)
	5: Pack[1](B)
	6: Pack[2](C)
	7: StLoc[3](loc3: C)
	8: ImmBorrowLoc[3](loc3: C)
	9: ImmBorrowField[2](C.x: A)
	10: ImmBorrowField[0](A.u: u64)
	11: ReadRef
	12: ImmBorrowLoc[3](loc3: C)
	13: ImmBorrowField[3](C.y: B)
	14: ImmBorrowField[1](B.u: u64)
	15: ReadRef
	16: Add
	17: StLoc[0](loc0: u64)
	18: ImmBorrowLoc[3](loc3: C)
	19: ImmBorrowField[2](C.x: A)
	20: ImmBorrowField[4](A.b: bool)
	21: ReadRef
	22: BrFalse(29)
B1:
	23: ImmBorrowLoc[3](loc3: C)
	24: ImmBorrowField[3](C.y: B)
	25: ImmBorrowField[5](B.b: bool)
	26: ReadRef
	27: StLoc[1](loc1: bool)
	28: Branch(31)
B2:
	29: LdFalse
	30: StLoc[1](loc1: bool)
B3:
	31: MoveLoc[1](loc1: bool)
	32: MoveLoc[0](loc0: u64)
	33: Pack[0](A)
	34: StLoc[2](loc2: A)
	35: ImmBorrowLoc[3](loc3: C)
	36: ImmBorrowField[3](C.y: B)
	37: ImmBorrowField[1](B.u: u64)
	38: ReadRef
	39: ImmBorrowLoc[2](loc2: A)
	40: ImmBorrowField[0](A.u: u64)
	41: ReadRef
	42: Mul
	43: ImmBorrowLoc[3](loc3: C)
	44: ImmBorrowField[2](C.x: A)
	45: ImmBorrowField[0](A.u: u64)
	46: ReadRef
	47: Add
	48: Pop
	49: Ret
}
}