// Move bytecode v6
module 34.auction {
use 0000000000000000000000000000000000000000000000000000000000000001::aptos_coin;
use 0000000000000000000000000000000000000000000000000000000000000001::coin;
use 0000000000000000000000000000000000000000000000000000000000000001::signer;
use 0000000000000000000000000000000000000000000000000000000000000001::string;
use 0000000000000000000000000000000000000000000000000000000000000001::timestamp;
use 0000000000000000000000000000000000000000000000000000000000000003::token;
use 0000000000000000000000000000000000000000000000000000000000000003::token_transfers;
use 0000000000000000000000000000000000000000000000000000000000000034::access_control;
use 0000000000000000000000000000000000000000000000000000000000000034::token as 0token;


struct Auction has key {
	status: u64,
	token_id: TokenId,
	top_bid: u64,
	top_bidder: address,
	deadline: u64
}

entry public accept_bid_price(Arg0: &signer) {
B0:
	0: MoveLoc[0](Arg0: &signer)
	1: Call access_control::admin_only(&signer)
	2: Call auction_exists(): bool
	3: BrFalse(5)
B1:
	4: Branch(7)
B2:
	5: LdConst[3](U64: [0, 0, 0, 0, 0, 0, 0, 0])
	6: Abort
B3:
	7: Call auction_status(): u64
	8: LdConst[2](U64: [1, 0, 0, 0, 0, 0, 0, 0])
	9: Eq
	10: BrFalse(12)
B4:
	11: Branch(14)
B5:
	12: LdConst[1](U64: [2, 0, 0, 0, 0, 0, 0, 0])
	13: Abort
B6:
	14: Call finalize_auction_unchecked()
	15: Ret
}
auction_exists(): bool {
B0:
	0: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	1: Exists[0](Auction)
	2: Ret
}
auction_is_over(): bool {
B0:
	0: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	1: ImmBorrowGlobal[0](Auction)
	2: ImmBorrowField[0](Auction.deadline: u64)
	3: ReadRef
	4: Call timestamp::now_seconds(): u64
	5: Lt
	6: Ret
}
auction_status(): u64 {
B0:
	0: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	1: ImmBorrowGlobal[0](Auction)
	2: ImmBorrowField[1](Auction.status: u64)
	3: ReadRef
	4: Ret
}
public bid(Arg0: &signer, Arg1: Coin<AptosCoin>) {
L0:	loc2: u64
L1:	loc3: address
L2:	loc4: u64
L3:	loc5: signer
B0:
	0: Call auction_exists(): bool
	1: BrFalse(3)
B1:
	2: Branch(7)
B2:
	3: MoveLoc[0](Arg0: &signer)
	4: Pop
	5: LdConst[3](U64: [0, 0, 0, 0, 0, 0, 0, 0])
	6: Abort
B3:
	7: Call auction_status(): u64
	8: LdConst[2](U64: [1, 0, 0, 0, 0, 0, 0, 0])
	9: Eq
	10: BrFalse(15)
B4:
	11: Call auction_is_over(): bool
	12: Not
	13: StLoc[2](loc0: bool)
	14: Branch(17)
B5:
	15: LdFalse
	16: StLoc[2](loc0: bool)
B6:
	17: MoveLoc[2](loc0: bool)
	18: BrFalse(20)
B7:
	19: Branch(24)
B8:
	20: MoveLoc[0](Arg0: &signer)
	21: Pop
	22: LdConst[1](U64: [2, 0, 0, 0, 0, 0, 0, 0])
	23: Abort
B9:
	24: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	25: MutBorrowGlobal[0](Auction)
	26: StLoc[3](loc1: &mut Auction)
	27: ImmBorrowLoc[1](Arg1: Coin<AptosCoin>)
	28: Call coin::value<AptosCoin>(&Coin<AptosCoin>): u64
	29: CopyLoc[3](loc1: &mut Auction)
	30: ImmBorrowField[2](Auction.top_bid: u64)
	31: ReadRef
	32: Gt
	33: BrFalse(35)
B10:
	34: Branch(41)
B11:
	35: MoveLoc[0](Arg0: &signer)
	36: Pop
	37: MoveLoc[3](loc1: &mut Auction)
	38: Pop
	39: LdConst[0](U64: [3, 0, 0, 0, 0, 0, 0, 0])
	40: Abort
B12:
	41: ImmBorrowLoc[1](Arg1: Coin<AptosCoin>)
	42: Call coin::value<AptosCoin>(&Coin<AptosCoin>): u64
	43: StLoc[4](loc2: u64)
	44: MoveLoc[0](Arg0: &signer)
	45: Call signer::address_of(&signer): address
	46: StLoc[5](loc3: address)
	47: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	48: MoveLoc[1](Arg1: Coin<AptosCoin>)
	49: Call coin::deposit<AptosCoin>(address, Coin<AptosCoin>)
	50: CopyLoc[3](loc1: &mut Auction)
	51: ImmBorrowField[3](Auction.top_bidder: address)
	52: ReadRef
	53: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	54: Neq
	55: BrFalse(68)
B13:
	56: CopyLoc[3](loc1: &mut Auction)
	57: ImmBorrowField[2](Auction.top_bid: u64)
	58: ReadRef
	59: StLoc[6](loc4: u64)
	60: Call access_control::get_signer(): signer
	61: StLoc[7](loc5: signer)
	62: ImmBorrowLoc[7](loc5: signer)
	63: CopyLoc[3](loc1: &mut Auction)
	64: ImmBorrowField[3](Auction.top_bidder: address)
	65: ReadRef
	66: MoveLoc[6](loc4: u64)
	67: Call coin::transfer<AptosCoin>(&signer, address, u64)
B14:
	68: MoveLoc[4](loc2: u64)
	69: CopyLoc[3](loc1: &mut Auction)
	70: MutBorrowField[2](Auction.top_bid: u64)
	71: WriteRef
	72: MoveLoc[5](loc3: address)
	73: MoveLoc[3](loc1: &mut Auction)
	74: MutBorrowField[3](Auction.top_bidder: address)
	75: WriteRef
	76: Ret
}
entry public finalize_auction() {
B0:
	0: Call auction_exists(): bool
	1: BrFalse(3)
B1:
	2: Branch(5)
B2:
	3: LdConst[3](U64: [0, 0, 0, 0, 0, 0, 0, 0])
	4: Abort
B3:
	5: Call auction_status(): u64
	6: LdConst[2](U64: [1, 0, 0, 0, 0, 0, 0, 0])
	7: Eq
	8: BrFalse(10)
B4:
	9: Branch(12)
B5:
	10: LdConst[1](U64: [2, 0, 0, 0, 0, 0, 0, 0])
	11: Abort
B6:
	12: Call auction_is_over(): bool
	13: BrFalse(15)
B7:
	14: Branch(17)
B8:
	15: LdConst[4](U64: [4, 0, 0, 0, 0, 0, 0, 0])
	16: Abort
B9:
	17: Call finalize_auction_unchecked()
	18: Ret
}
finalize_auction_unchecked() {
L0:	loc0: &mut Auction
L1:	loc1: signer
L2:	loc2: address
B0:
	0: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	1: MutBorrowGlobal[0](Auction)
	2: StLoc[0](loc0: &mut Auction)
	3: LdConst[1](U64: [2, 0, 0, 0, 0, 0, 0, 0])
	4: CopyLoc[0](loc0: &mut Auction)
	5: MutBorrowField[1](Auction.status: u64)
	6: WriteRef
	7: Call access_control::get_signer(): signer
	8: StLoc[1](loc1: signer)
	9: CopyLoc[0](loc0: &mut Auction)
	10: ImmBorrowField[3](Auction.top_bidder: address)
	11: ReadRef
	12: StLoc[2](loc2: address)
	13: CopyLoc[2](loc2: address)
	14: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	15: Neq
	16: BrFalse(31)
B1:
	17: ImmBorrowLoc[1](loc1: signer)
	18: Call access_control::get_admin(): address
	19: CopyLoc[0](loc0: &mut Auction)
	20: ImmBorrowField[2](Auction.top_bid: u64)
	21: ReadRef
	22: Call coin::transfer<AptosCoin>(&signer, address, u64)
	23: ImmBorrowLoc[1](loc1: signer)
	24: MoveLoc[2](loc2: address)
	25: MoveLoc[0](loc0: &mut Auction)
	26: ImmBorrowField[4](Auction.token_id: TokenId)
	27: ReadRef
	28: LdU64(1)
	29: Call token_transfers::offer(&signer, address, TokenId, u64)
	30: Branch(38)
B2:
	31: ImmBorrowLoc[1](loc1: signer)
	32: Call access_control::get_admin(): address
	33: MoveLoc[0](loc0: &mut Auction)
	34: ImmBorrowField[4](Auction.token_id: TokenId)
	35: ReadRef
	36: LdU64(1)
	37: Call token_transfers::offer(&signer, address, TokenId, u64)
B3:
	38: Ret
}
public get_auction_status(): u64 {
B0:
	0: Call auction_exists(): bool
	1: BrFalse(3)
B1:
	2: Branch(5)
B2:
	3: LdConst[3](U64: [0, 0, 0, 0, 0, 0, 0, 0])
	4: Abort
B3:
	5: Call auction_status(): u64
	6: Ret
}
public get_auction_token_id(): TokenId {
B0:
	0: Call auction_exists(): bool
	1: BrFalse(3)
B1:
	2: Branch(5)
B2:
	3: LdConst[3](U64: [0, 0, 0, 0, 0, 0, 0, 0])
	4: Abort
B3:
	5: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	6: ImmBorrowGlobal[0](Auction)
	7: ImmBorrowField[4](Auction.token_id: TokenId)
	8: ReadRef
	9: Ret
}
entry public redeem_bottle(Arg0: &signer) {
L0:	loc1: u64
B0:
	0: Call auction_exists(): bool
	1: BrFalse(3)
B1:
	2: Branch(7)
B2:
	3: MoveLoc[0](Arg0: &signer)
	4: Pop
	5: LdConst[3](U64: [0, 0, 0, 0, 0, 0, 0, 0])
	6: Abort
B3:
	7: Call auction_status(): u64
	8: StLoc[2](loc1: u64)
	9: CopyLoc[2](loc1: u64)
	10: LdConst[2](U64: [1, 0, 0, 0, 0, 0, 0, 0])
	11: Eq
	12: BrFalse(17)
B4:
	13: MoveLoc[0](Arg0: &signer)
	14: Pop
	15: LdConst[4](U64: [4, 0, 0, 0, 0, 0, 0, 0])
	16: Abort
B5:
	17: MoveLoc[2](loc1: u64)
	18: LdConst[0](U64: [3, 0, 0, 0, 0, 0, 0, 0])
	19: Eq
	20: BrFalse(25)
B6:
	21: MoveLoc[0](Arg0: &signer)
	22: Pop
	23: LdConst[5](U64: [6, 0, 0, 0, 0, 0, 0, 0])
	24: Abort
B7:
	25: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	26: MutBorrowGlobal[0](Auction)
	27: StLoc[1](loc0: &mut Auction)
	28: LdConst[0](U64: [3, 0, 0, 0, 0, 0, 0, 0])
	29: CopyLoc[1](loc0: &mut Auction)
	30: MutBorrowField[1](Auction.status: u64)
	31: WriteRef
	32: MoveLoc[1](loc0: &mut Auction)
	33: ImmBorrowField[4](Auction.token_id: TokenId)
	34: MoveLoc[0](Arg0: &signer)
	35: Call signer::address_of(&signer): address
	36: LdU64(1)
	37: Call 0token::burn(&TokenId, address, u64)
	38: Ret
}
entry public start_auction(Arg0: &signer, Arg1: u64, Arg2: u64, Arg3: String, Arg4: String, Arg5: String) {
B0:
	0: MoveLoc[0](Arg0: &signer)
	1: Call access_control::admin_only(&signer)
	2: Call timestamp::now_seconds(): u64
	3: CopyLoc[1](Arg1: u64)
	4: Lt
	5: BrFalse(7)
B1:
	6: Branch(9)
B2:
	7: LdConst[2](U64: [1, 0, 0, 0, 0, 0, 0, 0])
	8: Abort
B3:
	9: Call access_control::get_signer(): signer
	10: StLoc[7](loc1: signer)
	11: MoveLoc[3](Arg3: String)
	12: MoveLoc[4](Arg4: String)
	13: MoveLoc[5](Arg5: String)
	14: Call 0token::mint(String, String, String): TokenId
	15: StLoc[8](loc2: TokenId)
	16: LdConst[2](U64: [1, 0, 0, 0, 0, 0, 0, 0])
	17: MoveLoc[8](loc2: TokenId)
	18: MoveLoc[2](Arg2: u64)
	19: LdConst[7](Address: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52])
	20: MoveLoc[1](Arg1: u64)
	21: Pack[0](Auction)
	22: StLoc[6](loc0: Auction)
	23: ImmBorrowLoc[7](loc1: signer)
	24: MoveLoc[6](loc0: Auction)
	25: MoveTo[0](Auction)
	26: Ret
}
}