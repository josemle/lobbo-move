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


module algomove::agnostic_auction_paper_coin {

  use std::signer;
  use aptos_std::coin::{Self,Coin};

  struct Auction<phantom CoinType> has key {
    auctioneer: address,
    top_bid: Coin<CoinType>,
    top_bidder: address,
    expired: bool
  }

  public entry fun start_auction<CoinType>(auctioneer: &signer, base: Coin<CoinType>) {
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
    let auction = borrow_global_mut<Auction<CoinType>>(auctioneer_addr);
    let coin_amount = coin::value(&coins);
    assert!(!auction.expired, 1);
    assert!(coin_amount > coin::value(&auction.top_bid), 2);
    coin::deposit(auction.top_bidder, auction.top_bid);
    //coin::deposit(auctioneer_addr, coins);
    let a2 = Auction<CoinType> { 
        auctioneer: auction.auctioneer,
        top_bid: coins,
        top_bidder: signer::address_of(acc),
        expired: false
    };
    // Lore, anche se cambio idea di fondo, cioe' anziche assegnare un campo rifaccio una move_to con una nuova struct, il risultato non cambia: mi manca il signer per farlo
    // morale della favola, non possiamo fare pagamenti a nome 
    *auction = a2;
  }
    
  public fun finalize_auction<CoinType>(auctioneer: &signer) acquires Auction {
    let auctioneer_addr = signer::address_of(auctioneer);
    let auction = borrow_global_mut<Auction<CoinType>>(auctioneer_addr);
    assert!(auctioneer_addr == auction.auctioneer, 3);
    auction.expired = true;
  }

}
