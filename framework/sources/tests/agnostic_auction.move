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
