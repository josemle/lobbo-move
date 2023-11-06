module algomove::agnostic_auction {

  use std::signer;

  struct Auction has key {
    owner: address,
    top_bid: u64,
    top_bidder: address,
    expired: bool
  }

  public entry fun start_auction(owner: &signer, price: u64) {
    let owner_addr = signer::address_of(owner);
    let auction = Auction { 
      owner: owner_addr,
      top_bid: price,
      expired: false,
      top_bidder: owner_addr 
    };
    move_to(owner, auction)
  }

  public fun bid(acc: &signer, owner_addr: address, amount: u64) acquires Auction{
    let auction = borrow_global_mut<Auction>(owner_addr);
    assert!(!auction.expired, 0); 
    auction.top_bid = amount;
    auction.top_bidder = signer::address_of(acc);
  }

  public fun finalize_auction(owner: &signer): address acquires Auction {
    let owner_addr = signer::address_of(owner);
    let auction = borrow_global_mut<Auction>(owner_addr);
    assert!(owner_addr == auction.owner, 1);
    auction.expired = true;
    auction.top_bidder
  }

}

module algomove::agnostic_auction_paper {

  use std::signer;
  use aptos_std::coin::{value, Coin};

/*  struct Coin<CoinType> has store {
    value: u64
  }*/

  struct Auction has key {
    auctioneer: address,
    top_bid: u64,
    top_bidder: address,
    expired: bool
  }

  public entry fun start_auction(auctioneer: &signer, base: u64) {
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
    let auction = borrow_global_mut<Auction>(auctioneer_addr);
    let coin_amount = value(&coins);
    assert!(!auction.expired);
    assert!(coin_amount > value(&auction.top_bid));
    coin::deposit(auction.top_bidder, auction.top_bid);
    coin::deposit(auctioneer_addr, coins);
    auction.top_bid = coin_amount;
    auction.top_bidder = signer::address_of(acc);
  }
    
  public fun finalize_auction(auctioneer: &signer) {
    let auctioneer_addr = signer::address_of(auctioneer);
    let auction = borrow_global_mut<Auction>(auctioneer_addr);
    assert!(auctioneer_addr == auction.auctioneer);
    auction.expired = true;
  }

}