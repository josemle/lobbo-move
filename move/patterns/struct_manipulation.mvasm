// Move bytecode v6
module 221e04878647f87928e83d1a0f0ec826a40364527027dca5a940d6ae95e8fdf1.struct_manipulation {
struct A has drop, store, key {
	a: bool,
	b: u64
}
struct B has drop, store, key {
	a: bool,
	b: u64
}
struct Nested has drop, key {
	a: A,
	b: B
}
struct Nested1 has drop {
	a: Simple,
	b: u64
}
struct Simple has drop {
	f: u64,
	g: bool
}

public borrow_manipulation(Arg0: address): bool {
L0:	loc1: &mut A
L1:	loc2: &mut B
L2:	loc3: &mut Nested
B0:
	0: CopyLoc[0](Arg0: address)
	1: MutBorrowGlobal[0](A)
	2: StLoc[2](loc1: &mut A)
	3: CopyLoc[0](Arg0: address)
	4: MutBorrowGlobal[1](B)
	5: StLoc[3](loc2: &mut B)
	6: MoveLoc[0](Arg0: address)
	7: MutBorrowGlobal[2](Nested)
	8: StLoc[4](loc3: &mut Nested)
	9: MoveLoc[2](loc1: &mut A)
	10: ImmBorrowField[0](A.b: u64)
	11: ReadRef
	12: MoveLoc[3](loc2: &mut B)
	13: ImmBorrowField[1](B.b: u64)
	14: ReadRef
	15: Add
	16: CopyLoc[4](loc3: &mut Nested)
	17: ImmBorrowField[2](Nested.a: A)
	18: ImmBorrowField[0](A.b: u64)
	19: ReadRef
	20: MoveLoc[4](loc3: &mut Nested)
	21: ImmBorrowField[3](Nested.b: B)
	22: ImmBorrowField[1](B.b: u64)
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
entry public manipulate1() {
L0:	loc0: Nested1
B0:
	0: LdU64(5)
	1: LdFalse
	2: Pack[4](Simple)
	3: LdU64(78)
	4: Pack[3](Nested1)
	5: StLoc[0](loc0: Nested1)
	6: ImmBorrowLoc[0](loc0: Nested1)
	7: ImmBorrowField[4](Nested1.a: Simple)
	8: ImmBorrowField[5](Simple.f: u64)
	9: ReadRef
	10: ImmBorrowLoc[0](loc0: Nested1)
	11: ImmBorrowField[6](Nested1.b: u64)
	12: ReadRef
	13: Add
	14: MutBorrowLoc[0](loc0: Nested1)
	15: MutBorrowField[4](Nested1.a: Simple)
	16: MutBorrowField[5](Simple.f: u64)
	17: WriteRef
	18: Ret
}
public manipulate2(): u64 {
L0:	loc0: Nested
B0:
	0: LdTrue
	1: LdU64(18)
	2: Pack[0](A)
	3: LdFalse
	4: LdU64(77)
	5: Pack[1](B)
	6: Pack[2](Nested)
	7: StLoc[0](loc0: Nested)
	8: ImmBorrowLoc[0](loc0: Nested)
	9: ImmBorrowField[2](Nested.a: A)
	10: ImmBorrowField[0](A.b: u64)
	11: ReadRef
	12: ImmBorrowLoc[0](loc0: Nested)
	13: ImmBorrowField[3](Nested.b: B)
	14: ImmBorrowField[1](B.b: u64)
	15: ReadRef
	16: Add
	17: Ret
}
}