// Move bytecode v6
module 221e04878647f87928e83d1a0f0ec826a40364527027dca5a940d6ae95e8fdf1.struct_has_key {
struct Nested1 has store, key {
	a: Simple,
	b: u64
}
struct Nested2<Ty0: store> has key {
	a: Ty0,
	b: u64
}
struct Nested3 has store, key {
	a: Simple,
	b: u64,
	c: Simple
}
struct Simple has copy, drop, store, key {
	f: u64,
	g: bool
}

public borrow1(Arg0: address): u64 {
B0:
	0: MoveLoc[0](Arg0: address)
	1: MutBorrowGlobal[3](Simple)
	2: StLoc[1](loc0: &mut Simple)
	3: CopyLoc[1](loc0: &mut Simple)
	4: ImmBorrowField[0](Simple.f: u64)
	5: ReadRef
	6: LdU64(2)
	7: Add
	8: CopyLoc[1](loc0: &mut Simple)
	9: MutBorrowField[0](Simple.f: u64)
	10: WriteRef
	11: MoveLoc[1](loc0: &mut Simple)
	12: ImmBorrowField[0](Simple.f: u64)
	13: ReadRef
	14: Ret
}
public borrow2(Arg0: address): u64 {
B0:
	0: MoveLoc[0](Arg0: address)
	1: MutBorrowGlobal[3](Simple)
	2: MutBorrowField[0](Simple.f: u64)
	3: StLoc[1](loc0: &mut u64)
	4: CopyLoc[1](loc0: &mut u64)
	5: ReadRef
	6: CopyLoc[1](loc0: &mut u64)
	7: WriteRef
	8: CopyLoc[1](loc0: &mut u64)
	9: ReadRef
	10: LdU64(2)
	11: Add
	12: CopyLoc[1](loc0: &mut u64)
	13: WriteRef
	14: MoveLoc[1](loc0: &mut u64)
	15: ReadRef
	16: Ret
}
public borrow3(Arg0: address): u64 {
L0:	loc1: &u64
L1:	loc2: u64
L2:	loc3: &Nested3
L3:	loc4: &Simple
B0:
	0: MoveLoc[0](Arg0: address)
	1: ImmBorrowGlobal[2](Nested3)
	2: StLoc[4](loc3: &Nested3)
	3: CopyLoc[4](loc3: &Nested3)
	4: ImmBorrowField[1](Nested3.a: Simple)
	5: StLoc[5](loc4: &Simple)
	6: MoveLoc[4](loc3: &Nested3)
	7: ImmBorrowField[2](Nested3.b: u64)
	8: ReadRef
	9: StLoc[3](loc2: u64)
	10: ImmBorrowLoc[3](loc2: u64)
	11: StLoc[2](loc1: &u64)
	12: MoveLoc[5](loc4: &Simple)
	13: ReadRef
	14: StLoc[1](loc0: Simple)
	15: ImmBorrowLoc[1](loc0: Simple)
	16: ImmBorrowField[0](Simple.f: u64)
	17: ReadRef
	18: MoveLoc[2](loc1: &u64)
	19: ReadRef
	20: Add
	21: Ret
}
public borrow4(Arg0: address) {
B0:
	0: MoveLoc[0](Arg0: address)
	1: MutBorrowGlobal[3](Simple)
	2: StLoc[1](loc0: &mut Simple)
	3: LdU64(1)
	4: LdTrue
	5: Pack[3](Simple)
	6: MoveLoc[1](loc0: &mut Simple)
	7: WriteRef
	8: Ret
}
public borrow5(Arg0: address): bool {
L0:	loc1: &mut Simple
L1:	loc2: &mut Nested1
L2:	loc3: &mut Nested3
B0:
	0: CopyLoc[0](Arg0: address)
	1: MutBorrowGlobal[3](Simple)
	2: StLoc[2](loc1: &mut Simple)
	3: CopyLoc[0](Arg0: address)
	4: MutBorrowGlobal[0](Nested1)
	5: StLoc[3](loc2: &mut Nested1)
	6: MoveLoc[0](Arg0: address)
	7: MutBorrowGlobal[2](Nested3)
	8: StLoc[4](loc3: &mut Nested3)
	9: MoveLoc[2](loc1: &mut Simple)
	10: ImmBorrowField[0](Simple.f: u64)
	11: ReadRef
	12: MoveLoc[3](loc2: &mut Nested1)
	13: ImmBorrowField[3](Nested1.b: u64)
	14: ReadRef
	15: Add
	16: MoveLoc[4](loc3: &mut Nested3)
	17: ImmBorrowField[2](Nested3.b: u64)
	18: ReadRef
	19: Add
	20: LdU64(100)
	21: Lt
	22: BrFalse(26)
B1:
	23: LdTrue
	24: StLoc[1](loc0: bool)
	25: Branch(28)
B2:
	26: LdFalse
	27: StLoc[1](loc0: bool)
B3:
	28: MoveLoc[1](loc0: bool)
	29: Ret
}
entry public main(Arg0: &signer) {
B0:
	0: CopyLoc[0](Arg0: &signer)
	1: Call moveto2(&signer)
	2: MoveLoc[0](Arg0: &signer)
	3: Call moveto2(&signer)
	4: Ret
}
public moveto1(Arg0: signer, Arg1: u64) {
B0:
	0: ImmBorrowLoc[0](Arg0: signer)
	1: MoveLoc[1](Arg1: u64)
	2: LdU64(39)
	3: Add
	4: LdTrue
	5: Pack[3](Simple)
	6: MoveTo[3](Simple)
	7: Ret
}
public moveto2(Arg0: &signer) {
L0:	loc1: u64
L1:	loc2: Simple
L2:	loc3: Nested1
L3:	loc4: Simple
B0:
	0: LdU64(5)
	1: StLoc[1](loc0: u64)
	2: CopyLoc[1](loc0: u64)
	3: LdFalse
	4: Pack[3](Simple)
	5: StLoc[3](loc2: Simple)
	6: CopyLoc[3](loc2: Simple)
	7: LdU64(78)
	8: Pack[0](Nested1)
	9: StLoc[4](loc3: Nested1)
	10: ImmBorrowLoc[3](loc2: Simple)
	11: ImmBorrowField[0](Simple.f: u64)
	12: ReadRef
	13: ImmBorrowLoc[4](loc3: Nested1)
	14: ImmBorrowField[3](Nested1.b: u64)
	15: ReadRef
	16: Add
	17: StLoc[2](loc1: u64)
B1:
	18: CopyLoc[2](loc1: u64)
	19: LdU64(100)
	20: Lt
	21: BrFalse(28)
B2:
	22: Branch(23)
B3:
	23: MoveLoc[2](loc1: u64)
	24: LdU64(1)
	25: Add
	26: StLoc[2](loc1: u64)
	27: Branch(18)
B4:
	28: MoveLoc[1](loc0: u64)
	29: LdTrue
	30: Pack[3](Simple)
	31: StLoc[5](loc4: Simple)
	32: CopyLoc[0](Arg0: &signer)
	33: MoveLoc[4](loc3: Nested1)
	34: MoveTo[0](Nested1)
	35: MoveLoc[0](Arg0: &signer)
	36: MoveLoc[5](loc4: Simple)
	37: MoveTo[3](Simple)
	38: Ret
}
public moveto3(Arg0: &signer) {
B0:
	0: MoveLoc[0](Arg0: &signer)
	1: LdU64(5)
	2: LdFalse
	3: Pack[3](Simple)
	4: LdU64(34)
	5: Pack[0](Nested1)
	6: LdU64(9099)
	7: PackGeneric[0](Nested2<Nested1>)
	8: MoveToGeneric[0](Nested2<Nested1>)
	9: Ret
}
public moveto4(Arg0: &signer) {
L0:	loc1: Nested3
B0:
	0: LdU64(5)
	1: LdFalse
	2: Pack[3](Simple)
	3: StLoc[1](loc0: Simple)
	4: CopyLoc[1](loc0: Simple)
	5: LdU64(88)
	6: MoveLoc[1](loc0: Simple)
	7: Pack[2](Nested3)
	8: StLoc[2](loc1: Nested3)
	9: MoveLoc[0](Arg0: &signer)
	10: MoveLoc[2](loc1: Nested3)
	11: MoveTo[2](Nested3)
	12: Ret
}
}