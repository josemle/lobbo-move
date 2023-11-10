module deploy_address::loz_auction {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};

    struct Auction<phantom CoinType> has key {
        id: UID,
        auctioneer: address,
        expired: bool,
        highest_bidder: address,
        highest_bid: Coin<CoinType>
    }

    public fun create<CoinType> (ctx: &mut TxContext, initial_bid: Coin<CoinType>) {
        transfer::share_object(Auction<CoinType> {
            id: object::new(ctx),
            auctioneer: tx_context::sender(ctx),
            expired: false,
            highest_bidder: tx_context::sender(ctx),
            highest_bid: initial_bid
        })
    }

    public fun bid<CoinType>(auction: &mut Auction<CoinType>, bid: Coin<CoinType>) {
        assert!(!auction.expired, 0);
        assert!(coin::value<CoinType>(&bid) > coin::value(&auction.highest_bid), 1);
        transfer::transfer<Coin<CoinType>>(auction.highest_bid, auction.highest_bidder);
        auction.highest_bid = bid;
    }
}