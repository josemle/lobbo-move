// Move bytecode v6
module f77304f0b8426e09de5799104bfbc0a0efbbdaef95b5c172fb93522a19d5ee9e.loops_and_rec {


public fib(Arg0: u64): u64 {
B0:
	0: CopyLoc[0](Arg0: u64)
	1: LdU64(2)
	2: Lt
	3: BrFalse(7)
B1:
	4: LdU64(1)
	5: StLoc[1](loc0: u64)
	6: Branch(17)
B2:
	7: CopyLoc[0](Arg0: u64)
	8: LdU64(1)
	9: Sub
	10: Call fib(u64): u64
	11: MoveLoc[0](Arg0: u64)
	12: LdU64(2)
	13: Sub
	14: Call fib(u64): u64
	15: Add
	16: StLoc[1](loc0: u64)
B3:
	17: MoveLoc[1](loc0: u64)
	18: Ret
}
public loop1() {
L0:	loc0: u64
B0:
	0: LdU64(0)
	1: StLoc[0](loc0: u64)
B1:
	2: CopyLoc[0](loc0: u64)
	3: LdU64(10)
	4: Lt
	5: BrFalse(12)
B2:
	6: Branch(7)
B3:
	7: MoveLoc[0](loc0: u64)
	8: LdU64(1)
	9: Add
	10: StLoc[0](loc0: u64)
	11: Branch(2)
B4:
	12: LdU64(10)
	13: Call loop2(u64)
	14: Ret
}
public loop2(Arg0: u64) {
B0:
	0: MoveLoc[0](Arg0: u64)
	1: LdU64(1)
	2: Sub
	3: StLoc[0](Arg0: u64)
	4: CopyLoc[0](Arg0: u64)
	5: LdU64(0)
	6: Le
	7: BrFalse(9)
B1:
	8: Branch(10)
B2:
	9: Branch(0)
B3:
	10: Ret
}
public loop3(Arg0: u64, Arg1: u64, Arg2: u64): u64 * u64 {
B0:
	0: MoveLoc[0](Arg0: u64)
	1: LdU64(1)
	2: Sub
	3: StLoc[0](Arg0: u64)
	4: CopyLoc[1](Arg1: u64)
	5: CopyLoc[0](Arg0: u64)
	6: Add
	7: StLoc[3](loc0: u64)
	8: CopyLoc[2](Arg2: u64)
	9: CopyLoc[0](Arg0: u64)
	10: Sub
	11: StLoc[4](loc1: u64)
	12: CopyLoc[0](Arg0: u64)
	13: LdU64(0)
	14: Gt
	15: BrFalse(17)
B1:
	16: Branch(18)
B2:
	17: Branch(0)
B3:
	18: MoveLoc[0](Arg0: u64)
	19: CopyLoc[3](loc0: u64)
	20: CopyLoc[4](loc1: u64)
	21: Add
	22: MoveLoc[3](loc0: u64)
	23: MoveLoc[4](loc1: u64)
	24: Sub
	25: Call loop3(u64, u64, u64): u64 * u64
	26: StLoc[5](loc2: u64)
	27: StLoc[1](Arg1: u64)
	28: MoveLoc[5](loc2: u64)
	29: StLoc[2](Arg2: u64)
	30: MoveLoc[1](Arg1: u64)
	31: MoveLoc[2](Arg2: u64)
	32: Ret
}
}