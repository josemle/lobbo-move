module algomove::aptos_auction_coin {

    use std::signer;
    use aptos_framework::coin::{Self, Coin};

    struct Auction<phantom CoinType> has key {
        auctioneer: address,
        top_bid: Coin<CoinType>,
        top_bidder: address,
        base: u64,
        expired: bool,
    }

    public fun start_auction<CoinType>(auctioneer: &signer, base: u64) {
        let auction = Auction<CoinType> { 
            auctioneer: signer::address_of(auctioneer),
            top_bid: coin::zero<CoinType>(),
            top_bidder: signer::address_of(auctioneer),
            base: base,
            expired: false
        };
        move_to(auctioneer, auction)
    }

    public fun bid<CoinType>(bidder: &signer, auctioneer: address, bid: Coin<CoinType>) acquires Auction {
        // TODO: add some more security checks
        let auction = borrow_global_mut<Auction<CoinType>>(auctioneer);
        assert!(!auction.expired, 0);
        assert!(coin::value<CoinType>(&bid) > auction.base, 1);
        assert!(coin::value<CoinType>(&bid) > coin::value<CoinType>(&auction.top_bid), 2);
        // Getting old bid
        if(auction.top_bidder != auctioneer) {
            let oldBidAmount = coin::value<CoinType>(&auction.top_bid);
            let oldBid = coin::extract<CoinType>(&mut auction.top_bid, oldBidAmount);
            // Sending back old bid to previous top bidder
            coin::deposit(auction.top_bidder, oldBid);
        };
        // Updating auction with new bid and new bidder
        auction.top_bidder = signer::address_of(bidder);
        coin::merge(&mut auction.top_bid, bid);
    }

    public fun finalize_auction<CoinType>(auctioneer: &signer) acquires Auction {
        let auctioneer_address = signer::address_of(auctioneer);
        let auction = borrow_global_mut<Auction<CoinType>>(auctioneer_address);
        assert!(!auction.expired, 0);
        // Could the following assert be avoided? Because the caller can only be the auctioneer, 
        // otherwise the borrow_global_mut would fail
        assert!(auctioneer_address == auction.auctioneer, 1);
        let highest_bid_value = coin::value<CoinType>(&auction.top_bid);
        let highest_bid = coin::extract<CoinType>(&mut auction.top_bid, highest_bid_value);
        auction.expired = true;
        coin::deposit(auctioneer_address, highest_bid);
    }


}