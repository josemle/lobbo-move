// Move bytecode v6
module aaaa.borrow_field_order {
struct A has copy, drop, store, key {
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

public borrow_manipulation(Arg0: address): bool /* def_idx: 0 */ {
L1:	loc0: bool
L2:	loc1: &mut A
L3:	loc2: &mut B
L4:	loc3: &mut C
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
	9: CopyLoc[4](loc3: &mut C)
	10: ImmBorrowField[0](C.x: A)
	11: ImmBorrowField[1](A.u: u64)
	12: ReadRef
	13: MoveLoc[4](loc3: &mut C)
	14: ImmBorrowField[2](C.y: B)
	15: ImmBorrowField[3](B.u: u64)
	16: ReadRef
	17: Add
	18: MoveLoc[2](loc1: &mut A)
	19: ImmBorrowField[1](A.u: u64)
	20: ReadRef
	21: MoveLoc[3](loc2: &mut B)
	22: ImmBorrowField[3](B.u: u64)
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
entry public manipulation() /* def_idx: 1 */ {
L0:	loc0: u64
L1:	loc1: u64
L2:	loc2: bool
L3:	loc3: A
L4:	loc4: C
L5:	loc5: u64
B0:
	0: LdU64(5)
	1: StLoc[5](loc5: u64)
	2: ImmBorrowLoc[5](loc5: u64)
	3: Pop
	4: MoveLoc[5](loc5: u64)
	5: StLoc[0](loc0: u64)
	6: LdFalse
	7: MoveLoc[0](loc0: u64)
	8: Pack[0](A)
	9: LdTrue
	10: LdU64(18)
	11: Pack[1](B)
	12: Pack[2](C)
	13: StLoc[4](loc4: C)
	14: ImmBorrowLoc[4](loc4: C)
	15: ImmBorrowField[0](C.x: A)
	16: ImmBorrowField[1](A.u: u64)
	17: ReadRef
	18: ImmBorrowLoc[4](loc4: C)
	19: ImmBorrowField[2](C.y: B)
	20: ImmBorrowField[3](B.u: u64)
	21: ReadRef
	22: Add
	23: StLoc[1](loc1: u64)
	24: ImmBorrowLoc[4](loc4: C)
	25: ImmBorrowField[0](C.x: A)
	26: ImmBorrowField[4](A.b: bool)
	27: ReadRef
	28: BrFalse(35)
B1:
	29: ImmBorrowLoc[4](loc4: C)
	30: ImmBorrowField[2](C.y: B)
	31: ImmBorrowField[5](B.b: bool)
	32: ReadRef
	33: StLoc[2](loc2: bool)
	34: Branch(37)
B2:
	35: LdFalse
	36: StLoc[2](loc2: bool)
B3:
	37: MoveLoc[2](loc2: bool)
	38: MoveLoc[1](loc1: u64)
	39: Pack[0](A)
	40: StLoc[3](loc3: A)
	41: ImmBorrowLoc[4](loc4: C)
	42: ImmBorrowField[2](C.y: B)
	43: ImmBorrowField[3](B.u: u64)
	44: ReadRef
	45: ImmBorrowLoc[3](loc3: A)
	46: ImmBorrowField[1](A.u: u64)
	47: ReadRef
	48: Mul
	49: ImmBorrowLoc[4](loc4: C)
	50: ImmBorrowField[0](C.x: A)
	51: ImmBorrowField[1](A.u: u64)
	52: ReadRef
	53: Add
	54: Pop
	55: Ret
}
public read_ref1(Arg0: &u64): u64 /* def_idx: 2 */ {
B0:
	0: MoveLoc[0](Arg0: &u64)
	1: ReadRef
	2: LdU64(1)
	3: Add
	4: Ret
}
public read_ref2(Arg0: &A): u64 /* def_idx: 3 */ {
B0:
	0: MoveLoc[0](Arg0: &A)
	1: ImmBorrowField[1](A.u: u64)
	2: ReadRef
	3: Ret
}
public read_ref_caller(Arg0: address) /* def_idx: 4 */ {
L1:	loc0: A
L2:	loc1: C
L3:	loc2: &mut A
L4:	loc3: u64
B0:
	0: LdTrue
	1: LdU64(78)
	2: Pack[0](A)
	3: StLoc[1](loc0: A)
	4: MoveLoc[0](Arg0: address)
	5: MutBorrowGlobal[0](A)
	6: StLoc[3](loc2: &mut A)
	7: ImmBorrowLoc[1](loc0: A)
	8: ImmBorrowField[1](A.u: u64)
	9: Call read_ref1(&u64): u64
	10: Pop
	11: LdU64(56)
	12: StLoc[4](loc3: u64)
	13: ImmBorrowLoc[4](loc3: u64)
	14: Call read_ref1(&u64): u64
	15: Pop
	16: CopyLoc[1](loc0: A)
	17: LdTrue
	18: LdU64(18)
	19: Pack[1](B)
	20: Pack[2](C)
	21: StLoc[2](loc1: C)
	22: ImmBorrowLoc[2](loc1: C)
	23: ImmBorrowField[0](C.x: A)
	24: ImmBorrowField[1](A.u: u64)
	25: Call read_ref1(&u64): u64
	26: Pop
	27: ImmBorrowLoc[1](loc0: A)
	28: Call read_ref2(&A): u64
	29: Pop
	30: MoveLoc[3](loc2: &mut A)
	31: FreezeRef
	32: Call read_ref2(&A): u64
	33: Pop
	34: Ret
}
}