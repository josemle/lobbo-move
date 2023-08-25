module resource_account_addr::auction {
  use aptos_framework::timestamp;
  use aptos_framework::signer;
  use aptos_framework::aptos_coin;
  use aptos_framework::coin;
  use aptos_token::token;
  use aptos_token::token_transfers;
  use std::string::String;

  // error codes
  const AUCTION_NOT_EXISTS: u64 = 0;
  const EDEADLINE_IN_PAST: u64 = 1;
  const EAUCTION_IS_FINISHED: u64 = 2;
  const EBID_TOO_LOW: u64 = 3;
  const EAUCTION_IS_NOT_OVER_YET: u64 = 4;
  const ENOT_AUCTION_WINNER: u64 = 5;
  const EBOTTLE_ALREADY_REDEEMED: u64 = 6;

  // auction status codes
  const AUCTION_LIVE: u64 = 1;
  const AUCTION_FINISHED: u64 = 2;
  const AUCTION_BOTTLE_REDEEMED: u64 = 3;

  struct Auction has key {
    status: u64,
    token_id: aptos_token::token::TokenId,
    top_bid: u64,
    top_bidder: address,
    deadline: u64
  }

  public entry fun start_auction(
    admin: &signer,
    deadline: u64,
    starting_price: u64,
    token_name: String,
    token_description: String,
    token_metadata_uri: String,
  ) {
    resource_account_addr::access_control::admin_only(admin);
    assert!(timestamp::now_seconds() < deadline, EDEADLINE_IN_PAST);
    let resource_account_signer = resource_account_addr::access_control::get_signer();
    let token_id = resource_account_addr::token::mint(token_name, token_description, token_metadata_uri);
    let auction = Auction {
      status: AUCTION_LIVE,
      token_id,
      top_bid: starting_price,
      top_bidder: @resource_account_addr,
      deadline
    };
    move_to(&resource_account_signer, auction)
  }

  public fun bid(
    bidder: &signer,
    coin: coin::Coin<aptos_coin::AptosCoin>
  ) acquires Auction {
    assert!(auction_exists(), AUCTION_NOT_EXISTS);
    assert!(auction_status() == AUCTION_LIVE && !auction_is_over(), EAUCTION_IS_FINISHED);
    let auction = borrow_global_mut<Auction>(@resource_account_addr);
    assert!(coin::value(&coin) > auction.top_bid, EBID_TOO_LOW);
    let new_top_bid = coin::value(&coin);
    let new_top_bidder = signer::address_of(bidder);
    // accept the new bid
    coin::deposit<aptos_coin::AptosCoin>(@resource_account_addr, coin);
    let previous_top_bidder = auction.top_bidder;
    if (previous_top_bidder != @resource_account_addr) {
      // return the previous highest bid to the bidder if there was at least one legitimate bid
      let previous_top_bid = auction.top_bid;
      let resource_account_signer = resource_account_addr::access_control::get_signer();
      coin::transfer<aptos_coin::AptosCoin>(&resource_account_signer, auction.top_bidder, previous_top_bid);
    };
    auction.top_bid = new_top_bid;
    auction.top_bidder = new_top_bidder;
  }

  public entry fun accept_bid_price(
    admin: &signer,
  ) acquires Auction {
    resource_account_addr::access_control::admin_only(admin);
    assert!(auction_exists(), AUCTION_NOT_EXISTS);
    assert!(auction_status() == AUCTION_LIVE, EAUCTION_IS_FINISHED);
    finalize_auction_unchecked();
  }

  public entry fun finalize_auction() acquires Auction {
    assert!(auction_exists(), AUCTION_NOT_EXISTS);
    assert!(auction_status() == AUCTION_LIVE, EAUCTION_IS_FINISHED);
    assert!(auction_is_over(), EAUCTION_IS_NOT_OVER_YET);
    finalize_auction_unchecked();
  }

  public entry fun redeem_bottle(owner: &signer) acquires Auction {
    assert!(auction_exists(), AUCTION_NOT_EXISTS);
    let auction_status = auction_status();
    if (auction_status == AUCTION_LIVE) {
      abort EAUCTION_IS_NOT_OVER_YET
    } else if (auction_status == AUCTION_BOTTLE_REDEEMED) {
      abort EBOTTLE_ALREADY_REDEEMED
    };
    let auction = borrow_global_mut<Auction>(@resource_account_addr);
    auction.status = AUCTION_BOTTLE_REDEEMED;
    resource_account_addr::token::burn(&auction.token_id, signer::address_of(owner), 1);
  }

  fun finalize_auction_unchecked() acquires Auction {
    let auction = borrow_global_mut<Auction>(@resource_account_addr);
    auction.status = AUCTION_FINISHED;
    let resource_account_signer = resource_account_addr::access_control::get_signer();
    let top_bidder = auction.top_bidder;
    // Transfer APT and offer a token only if there was at least one legitimate bettor
    if (top_bidder != @resource_account_addr) {
      // transfer APT to the admin
      coin::transfer<aptos_coin::AptosCoin>(&resource_account_signer, resource_account_addr::access_control::get_admin(), auction.top_bid);
      // offer won token to the top bidder so he can later accept it
      token_transfers::offer(&resource_account_signer, top_bidder, auction.token_id, 1);
    } else {
      // otherwise just offer the token to the admin
      token_transfers::offer(&resource_account_signer, resource_account_addr::access_control::get_admin(), auction.token_id, 1);
    };
  }

  #[view]
  public fun get_auction_token_id(): token::TokenId acquires Auction {
    assert!(auction_exists(), AUCTION_NOT_EXISTS);
    borrow_global<Auction>(@resource_account_addr).token_id
  }

  #[view]
  public fun get_auction_status(): u64 acquires Auction {
    assert!(auction_exists(), AUCTION_NOT_EXISTS);
    auction_status()
  }

  fun auction_status(): u64 acquires Auction {
    borrow_global<Auction>(@resource_account_addr).status
  }

  fun auction_exists(): bool{
    exists<Auction>(@resource_account_addr)
  }

  fun auction_is_over(): bool acquires Auction {
    (borrow_global<Auction>(@resource_account_addr)).deadline < timestamp::now_seconds()
  }

  #[test_only]
  public fun get_auction_live_status(): u64 {
    AUCTION_LIVE
  }

  #[test_only]
  public fun get_auction_bottle_redeemed_status(): u64 {
    AUCTION_BOTTLE_REDEEMED
  }

  #[test_only]
  public fun auction_exists_test(): bool {
    auction_exists()
  }
}