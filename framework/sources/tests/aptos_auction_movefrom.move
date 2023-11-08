

module algomove::aptos_auction_paper_movefrom {

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

  public fun bid<CoinType>(acc: &signer, top_bidder_addr: address, coins: Coin<CoinType>): address acquires Auction {
    let Auction { auctioneer, top_bid, top_bidder, expired } = move_from<Auction<CoinType>>(top_bidder_addr);
    assert!(top_bidder_addr == top_bidder, 0);
    assert!(!expired, 1);
    assert!(coin::value(&coins) > coin::value(&top_bid), 2);
    coin::deposit(top_bidder, top_bid);
    let new_top_bidder = signer::address_of(acc);
    move_to(acc, Auction { auctioneer, top_bid: coins, top_bidder: new_top_bidder, expired });
    new_top_bidder
  }
    
  public fun finalize_auction<CoinType>(auctioneer: &signer) acquires Auction {
    let auctioneer_addr = signer::address_of(auctioneer);
    let auction = borrow_global_mut<Auction<CoinType>>(auctioneer_addr);
    assert!(auctioneer_addr == auction.auctioneer, 3);
    auction.expired = true;
  }

}
