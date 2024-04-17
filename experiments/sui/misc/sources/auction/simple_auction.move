module deploy_address::simple_auction {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    struct Auction has key {
        id: UID,
        auctioneer: address,
        expired: bool,
        highest_bidder: address,
        highest_bid: u64
    }

    public fun create(ctx: &mut TxContext) {
        transfer::share_object(Auction {
            id: object::new(ctx),
            auctioneer: tx_context::sender(ctx),
            expired: false,
            highest_bidder: tx_context::sender(ctx),
            highest_bid: 0
        })
    }

    public fun bid(auction: &mut Auction, amount: u64) {
        assert!(!auction.expired, 0);
        assert!(amount > auction.highest_bid, 1);
        auction.highest_bid = amount;
    }
}