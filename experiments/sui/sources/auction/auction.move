module deploy_address::loz_auction {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};

    struct Auction<phantom CoinType> has key {
        id: UID,
        auctioneer: address,
        expired: bool,
        top_bidder: address,
        top_bid: Coin<CoinType>
    }

    public fun create<CoinType>(ctx: &mut TxContext, initial_bid: Coin<CoinType>) {
        transfer::share_object(Auction<CoinType> {
            id: object::new(ctx),
            auctioneer: tx_context::sender(ctx),
            expired: false,
            top_bidder: tx_context::sender(ctx),
            top_bid: initial_bid
        })
    }

    public entry fun bid<CoinType>(auction: &mut Auction<CoinType>, bid: Coin<CoinType>) {
        //let Auction { id, auctioneer, expired, top_bidder, top_bid } = auction;
        assert!(!auction.expired, 0);
        assert!(coin::value<CoinType>(&bid) > coin::value(&auction.top_bid), 1);
        // QUESTA TRANSFER NON FUNZIONA, L'HO MESSA SOLO PER NON MOSTRARE ERRORI
        transfer::public_transfer(bid, auction.top_bidder);
        //transfer::receive<Coin<CoinType>>(id, auction.top_bid);
        //auction.top_bid = bid;
    }
}