module deploy_address::loz_auction {
    use sui::transfer;
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use std::vector;

    struct Auction<phantom CoinType> has key {
        id: UID,
        auctioneer: address,
        expired: bool,
        top_bidder: address,
    }

    struct Bid<phantom CoinType> has key {
        id: UID,
        coins: Coin<CoinType>
    }

    public entry fun start_auction<CoinType>(base: Coin<CoinType>, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        let auc = Auction<CoinType> {
            id: object::new(ctx),
            auctioneer: sender,
            expired: false,
            top_bidder: sender,
        };
        transfer::share_object(auc);
        transfer::share_object(Bid { id: object::new(ctx), coins: base });
    }

    /*public entry fun bid<CoinType>(auction: &mut Auction<CoinType>, bid: Coin<CoinType>) {
        let Auction { id, auctioneer, expired, top_bidder, top_bid } = auction;
        assert!(!auction.expired, 0);
        assert!(coin::value<CoinType>(&bid) > coin::value(&auction.top_bid), 1);
        transfer::public_transfer<Coin<CoinType>>(top_bid, top_bidder);
        auction.top_bid = bid;
    }*/

    fun swap<T : copy + drop>(r: &mut T, v: T): T {
        let tmp = *r;
        *r = v;
        tmp
    }

    fun swapL<T>(r: &mut vector<T>, v: T): T {
        let tmp = vector::pop_back(r);
        vector::push_back(r, v);
        tmp
    }

    public entry fun bid2<CoinType>(bid: Coin<CoinType>, auction: &mut Auction<CoinType>, last_bid: &mut Bid<CoinType>, ctx: &mut TxContext) {
        assert!(!auction.expired, 0);
        assert!(coin::value<CoinType>(&bid) > coin::value(&last_bid.coins), 1);
        transfer::public_transfer<Coin<CoinType>>(last_bid.coins, auction.top_bidder);  // non compila qui
        auction.top_bidder = tx_context::sender(ctx);
        transfer::share_object(Bid { id: object::new(ctx), coins: bid });
    }

}