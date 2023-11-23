module resource_account_addr::auction_simple {
  use aptos_framework::timestamp;
  use aptos_framework::signer;
  use aptos_framework::aptos_coin;
  use aptos_framework::coin;
  use aptos_framework::account;
  use aptos_framework::resource_account;


  // auction status codes
  const AUCTION_LIVE: u64 = 1;
  const AUCTION_FINISHED: u64 = 2;

  struct Auction has key {
    status: u64,
    top_bid: u64,
    top_bidder: address,
    deadline: u64
  }

  struct AccessControl has key {
    resource_signer_cap: account::SignerCapability,
    admin: address,
  }

  fun init_module(account: &signer) {
    let resource_cap = resource_account::retrieve_resource_account_cap(account, @source_addr);
    move_to(
      account,
      AccessControl {
        resource_signer_cap: resource_cap,
        admin: @source_addr,
      }
    );
  }

  public entry fun start_auction(
    deadline: u64,
    starting_price: u64,
  ) acquires AccessControl{
    assert!(timestamp::now_seconds() < deadline, 0);
    let resource_account_signer = get_signer();
    let auction = Auction {
      status: AUCTION_LIVE,
      top_bid: starting_price,
      top_bidder: @resource_account_addr,
      deadline
    };
    move_to(&resource_account_signer, auction)
  }

  public entry fun bid(
    bidder: &signer,
    coin: coin::Coin<aptos_coin::AptosCoin>
  ) acquires Auction, AccessControl {
    let auction = borrow_global_mut<Auction>(@resource_account_addr);
    let new_top_bid = coin::value(&coin);
    let new_top_bidder = signer::address_of(bidder);
    // accept the new bid
    coin::deposit<aptos_coin::AptosCoin>(@resource_account_addr, coin);
    let previous_top_bidder = auction.top_bidder;
    if (previous_top_bidder != @resource_account_addr) {
      // return the previous highest bid to the bidder if there was at least one legitimate bid
      let previous_top_bid = auction.top_bid;
      let resource_account_signer = get_signer();
      coin::transfer<aptos_coin::AptosCoin>(&resource_account_signer, auction.top_bidder, previous_top_bid);
    };
    auction.top_bid = new_top_bid;
    auction.top_bidder = new_top_bidder;
  }

  public entry fun finalize_auction() acquires Auction, AccessControl {
    let auction = borrow_global_mut<Auction>(@resource_account_addr);
    auction.status = AUCTION_FINISHED;
    let resource_account_signer = get_signer();
    let top_bidder = auction.top_bidder;
    // Transfer APT and offer a token only if there was at least one legitimate bettor
    if (top_bidder != @resource_account_addr) {
      // transfer APT to the admin
      coin::transfer<aptos_coin::AptosCoin>(&resource_account_signer, get_admin(), auction.top_bid);
    };
  }

  fun get_signer(): signer acquires AccessControl {
    let resource_signer = account::create_signer_with_capability(
      &borrow_global<AccessControl>(@resource_account_addr).resource_signer_cap
    );
    resource_signer
  }

  public fun get_admin(): address acquires AccessControl {
    borrow_global<AccessControl>(@resource_account_addr).admin
  }
}