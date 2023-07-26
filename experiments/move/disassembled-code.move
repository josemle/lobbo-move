// Move bytecode v6
module f77304f0b8426e09de5799104bfbc0a0efbbdaef95b5c172fb93522a19d5ee9e.lambdas {
use 0000000000000000000000000000000000000000000000000000000000000001::debug;




public foo(Arg0: u64): u64 {
B0:
	0: MoveLoc[0](Arg0: u64)
	1: LdU64(2)
	2: Mul
	3: Ret
}
public main() {
L0:	loc0: u64
L1:	loc1: vector<u64>
L2:	loc2: u64
L3:	loc3: u64
B0:
	0: LdU64(8)
	1: StLoc[2](loc2: u64)
	2: CopyLoc[2](loc2: u64)
	3: MoveLoc[2](loc2: u64)
	4: Add
	5: LdU64(10)
	6: Mul
	7: Call foo(u64): u64
	8: Pop
	9: VecPack(0, 0)
	10: StLoc[1](loc1: vector<u64>)
	11: LdU64(0)
	12: StLoc[0](loc0: u64)
B1:
	13: CopyLoc[0](loc0: u64)
	14: ImmBorrowLoc[1](loc1: vector<u64>)
	15: VecLen(0)
	16: Lt
	17: BrFalse(27)
B2:
	18: Branch(19)
B3:
	19: ImmBorrowLoc[1](loc1: vector<u64>)
	20: CopyLoc[0](loc0: u64)
	21: VecImmBorrow(0)
	22: ReadRef
	23: StLoc[3](loc3: u64)
	24: ImmBorrowLoc[3](loc3: u64)
	25: Call debug::print<u64>(&u64)
	26: Branch(13)
B4:
	27: Ret
}
}