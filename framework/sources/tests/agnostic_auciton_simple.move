module algomove::agnostic_auction_paper_simple {

  use std::signer;
  use aptos_std::coin;

  struct Auction has key {
    auctioneer: address,
    top_bid: u64,
    top_bidder: address,
    expired: bool
  }

  public entry fun start_auction(auctioneer: &signer, base: u64) {
    let auctioneer_addr = signer::address_of(auctioneer);
    let auction =
      Auction { 
        auctioneer: auctioneer_addr,
        top_bid: base,
        top_bidder: auctioneer_addr,
        expired: false
    };
    move_to(auctioneer, auction)
  }

  public entry fun bid(acc: &signer, auctioneer_addr: address, amount:u64) acquires Auction {
    let auction = borrow_global_mut<Auction>(auctioneer_addr);
    assert!(!auction.expired, 1);
    assert!(amount > auction.top_bid, 2);
    auction.top_bid = amount;
    auction.top_bidder = signer::address_of(acc);
  }
    
  public entry fun finalize_auction(auctioneer: &signer) acquires Auction {
    let auctioneer_addr = signer::address_of(auctioneer);
    let auction = borrow_global_mut<Auction>(auctioneer_addr);
    assert!(auctioneer_addr == auction.auctioneer, 3);
    auction.expired = true;
  }

  public entry fun winner_pays<CoinType>(acc: &signer, auctioneer: address) acquires Auction {
    let auction = borrow_global<Auction>(auctioneer);
    assert!(auction.expired, 4);
    assert!(auction.top_bidder == signer::address_of(acc), 5);
    coin::transfer<CoinType>(acc, auctioneer, auction.top_bid);
  }
}