
module algomove::aptos_auction_hybrid {

  use std::signer;
  use aptos_std::coin::{Self,Coin};

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

  public fun bid<CoinType>(acc: &signer, auctioneer_addr: address, coins: Coin<CoinType>) acquires Auction {
    let auction = borrow_global_mut<Auction>(auctioneer_addr);
    let coin_amount = coin::value(&coins);
    assert!(!auction.expired, 1);
    assert!(coin_amount > auction.top_bid, 2);
    // Lore, guarda qua: non riesco a fare la withdraw perche devo avere il signer
    //let refund = coin::withdraw<CoinType>(auctioneer_addr, auction.top_bid);
    //coin::deposit(auction.top_bidder, refund);
    coin::deposit(auctioneer_addr, coins);
    auction.top_bid = coin_amount;
    auction.top_bidder = signer::address_of(acc);
  }
    
  public fun finalize_auction(auctioneer: &signer) acquires Auction {
    let auctioneer_addr = signer::address_of(auctioneer);
    let auction = borrow_global_mut<Auction>(auctioneer_addr);
    assert!(auctioneer_addr == auction.auctioneer, 3);
    auction.expired = true;
  }
}

