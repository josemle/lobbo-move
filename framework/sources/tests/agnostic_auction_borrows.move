
module algomove::agnostic_auction_paper_borrows {

  use std::signer;
  use aptos_std::coin::{Self,Coin};

  struct Auction<phantom CoinType> has key {
    auctioneer: address,
    top_bid: Coin<CoinType>,
    top_bidder: address,
    expired: bool
  }

  public fun start_auction<CoinType>(auctioneer: &signer, base: Coin<CoinType>) {
    let auctioneer_addr = signer::address_of(auctioneer);
    let auction =
      Auction<CoinType> { 
        auctioneer: auctioneer_addr,
        top_bid: base,
        top_bidder: auctioneer_addr,
        expired: false
    };
    move_to(auctioneer, auction)
  }

  public fun bid<CoinType>(acc: &signer, auctioneer_addr: address, coins: Coin<CoinType>) acquires Auction {
    let Auction { auctioneer, top_bid, top_bidder, expired } = borrow_global_mut<Auction<CoinType>>(auctioneer_addr);
    assert!(!*expired, 1);
    assert!(coin::value(&coins) > coin::value(top_bid), 2);
    coin::deposit(*top_bidder, top_bid);
    top_bidder = signer::address_of(acc);
    top_bid = coins;
  }
    
  public fun finalize_auction<CoinType>(auctioneer: &signer) acquires Auction {
    let auctioneer_addr = signer::address_of(auctioneer);
    let auction = borrow_global_mut<Auction<CoinType>>(auctioneer_addr);
    assert!(auctioneer_addr == auction.auctioneer, 3);
    auction.expired = true;
  }


}