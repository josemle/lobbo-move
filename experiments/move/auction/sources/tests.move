#[test_only]
module resource_account_addr::tests {
  /*
  use aptos_framework::account;
  use aptos_framework::signer;
  use aptos_framework::timestamp;
  use aptos_framework::coin;
  use aptos_framework::aptos_coin;
  //use aptos_token::token;
  //use aptos_token::token_transfers;
  use resource_account_addr::auction;
  use resource_account_addr::access_control;
  use std::vector;
  use std::string;*/
  use aptos_std::debug::print;
  use aptos_std::string_utils;
	use std::string::utf8;

  /*
  // Error codes
  // Access control
  const EACCESS_CONTROL_FAILED_01: u64 = 1;
  const EACCESS_CONTROL_FAILED_02: u64 = 2;
  const EACCESS_CONTROL_FAILED_03: u64 = 3;
  // Token
  const ETOKEN_FAILED_01: u64 = 4;
  const ETOKEN_FAILED_02: u64 = 5;
  // Auction
  const EAUCTION_FAILED_01: u64 = 6;
  const EAUCTION_FAILED_02: u64 = 7;
  const EAUCTION_FAILED_03: u64 = 8;
  const EAUCTION_FAILED_04: u64 = 9;
  const EAUCTION_FAILED_05: u64 = 10;
  const EAUCTION_FAILED_06: u64 = 11;
  const EAUCTION_FAILED_07: u64 = 12;
  const EAUCTION_FAILED_08: u64 = 13;
  const EAUCTION_FAILED_09: u64 = 14;
  const EAUCTION_FAILED_10: u64 = 15;
  const EAUCTION_FAILED_11: u64 = 16;
  const EAUCTION_FAILED_12: u64 = 17;
  const EAUCTION_FAILED_13: u64 = 18;
  */
  // Helper functions
  /*
  fun set_up_testing_environment(
    resource_account: &signer,
    source_account: &signer,
    aptos_framework: &signer,
    other_accounts: vector<address>
  ) {
    timestamp::set_time_has_started_for_testing(aptos_framework);
    timestamp::update_global_time_for_test_secs(1);
    account::create_account_for_test(signer::address_of(resource_account));
    account::create_account_for_test(signer::address_of(source_account));
    while (!vector::is_empty<address>(&other_accounts)) {
      let account = vector::pop_back(&mut other_accounts);
      account::create_account_for_test(account);
    };
    access_control::init_module_test(resource_account);
    resource_account_addr::token::init_module_test(resource_account);
  }

  fun init_aptos_coin(
    aptos_framework: &signer,
    resource_account: &signer,
    source_account: &signer
  ): (coin::BurnCapability<aptos_coin::AptosCoin>, coin::MintCapability<aptos_coin::AptosCoin>) {
    let (burn_cap, mint_cap) = aptos_coin::initialize_for_test(aptos_framework);
    coin::register<aptos_coin::AptosCoin>(resource_account);
    coin::register<aptos_coin::AptosCoin>(source_account);
    (burn_cap, mint_cap)
  }

  fun start_new_auction(admin: &signer, timestamp_delta: u64) {
      let deadline_timestamp = timestamp::now_seconds() + timestamp_delta;
      let starting_price = 10;
      let token_name = string::utf8(b"Test");
      let token_description = string::utf8(b"Test");
      let token_uri = string::utf8(b"www.example.com");
      auction::start_auction(admin, deadline_timestamp, starting_price, token_name, token_description, token_uri);
  }

  fun clean_up(burn_cap: coin::BurnCapability<aptos_coin::AptosCoin>, mint_cap: coin::MintCapability<aptos_coin::AptosCoin>) {
    coin::destroy_burn_cap<aptos_coin::AptosCoin>(burn_cap);
    coin::destroy_mint_cap<aptos_coin::AptosCoin>(mint_cap);
  }
  
  // Access control tests

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, new_admin = @0x123)]
  fun access_control_basic_tests(resource_account: signer, source_account: signer, aptos_framework: signer, new_admin: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[signer::address_of(&new_admin)]);
    assert!(access_control::get_admin() == signer::address_of(&source_account), EACCESS_CONTROL_FAILED_01);
    access_control::change_admin(&source_account, signer::address_of(&new_admin));
    assert!(access_control::get_admin() == signer::address_of(&new_admin), EACCESS_CONTROL_FAILED_02);
    let access_control_signer = access_control::get_signer();
    assert!(signer::address_of(&access_control_signer) == signer::address_of(&resource_account), EACCESS_CONTROL_FAILED_03)
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, other_account = @0x123)]
  #[expected_failure(abort_code = access_control::ENOT_ADMIN)]
  fun access_control_admin_only_not_admin(resource_account: signer, source_account: signer, aptos_framework: signer, other_account: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[signer::address_of(&other_account)]);
    access_control::admin_only(&other_account);
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, other_account = @0x123)]
  fun access_control_admin_only_success(resource_account: signer, source_account: signer, aptos_framework: signer, other_account: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[signer::address_of(&other_account)]);
    access_control::admin_only(&source_account);
  }

  // Token tests

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework)]
  fun token_mint(resource_account: signer, source_account: signer, aptos_framework: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[]);
    let token_name = string::utf8(b"Test");
    let token_description = string::utf8(b"Test");
    let token_uri = string::utf8(b"www.example.com");
    let token_id = resource_account_addr::token::mint(token_name, token_description, token_uri);
    assert!(token::balance_of(@resource_account_addr, *&token_id) == 1, ETOKEN_FAILED_01);
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework)]
  fun token_burn(resource_account: signer, source_account: signer, aptos_framework: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[]);
    let token_name = string::utf8(b"Test");
    let token_description = string::utf8(b"Test");
    let token_uri = string::utf8(b"www.example.com");
    let token_id = resource_account_addr::token::mint(token_name, token_description, token_uri);
    resource_account_addr::token::burn(&token_id, @resource_account_addr, 1);
    assert!(token::balance_of(@resource_account_addr, *&token_id) == 0, ETOKEN_FAILED_02);
  }

  // Auction tests
  
  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, other_account = @0x123)]
  #[expected_failure(abort_code = access_control::ENOT_ADMIN)]
  fun auction_start_new_auction_not_admin(
    resource_account: signer,
    source_account: signer,
    aptos_framework: signer,
    other_account: signer
  ) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[signer::address_of(&other_account)]);
    start_new_auction(&other_account, 10);
  }
  
  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework)]
  #[expected_failure(abort_code = auction::EDEADLINE_IN_PAST)]
  fun auction_start_new_auction_bad_deadline(resource_account: signer, source_account: signer, aptos_framework: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[]);
    start_new_auction(&source_account, 0);
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework)]
  fun auction_start_new_auction_success(resource_account: signer, source_account: signer, aptos_framework: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[]);
    start_new_auction(&source_account, 10);
    assert!(auction::auction_exists_test(), EAUCTION_FAILED_04);
    assert!(auction::get_auction_status() == auction::get_auction_live_status(), EAUCTION_FAILED_05);
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, bidder = @0xb1d)]
  #[expected_failure(abort_code = auction::EBID_TOO_LOW)]
  fun auction_bid_too_low(resource_account: signer, source_account: signer, aptos_framework: signer, bidder: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[signer::address_of(&bidder)]);
    let (burn_cap, mint_cap) = init_aptos_coin(&aptos_framework, &resource_account, &source_account);
    let new_bid_amount = 10;
    let coin = coin::mint<aptos_coin::AptosCoin>(new_bid_amount, &mint_cap);
    start_new_auction(&source_account, 10);
    auction::bid(&bidder, coin);
    clean_up(burn_cap, mint_cap);
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, bidder = @0xb1d, second_bidder = @0xb2d)]
  fun auction_bid_success(resource_account: signer, source_account: signer, aptos_framework: signer, bidder: signer, second_bidder: signer) {
    set_up_testing_environment(
      &resource_account,
      &source_account,
      &aptos_framework,
      vector<address>[signer::address_of(&bidder), signer::address_of(&second_bidder)]
    );
    let (burn_cap, mint_cap) = init_aptos_coin(&aptos_framework, &resource_account, &source_account);
    let new_bid_amount = 11;
    let coin = coin::mint<aptos_coin::AptosCoin>(new_bid_amount, &mint_cap);
    start_new_auction(&source_account, 10);
    let balance_before = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&resource_account));
    auction::bid(&bidder, coin);
    let balance_after = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&resource_account));
    assert!(balance_before + new_bid_amount == balance_after, EAUCTION_FAILED_06);
    // another bid to verify that the first legitimate bidder successfully receives his bid after he was outbid
    let previous_top_bid = new_bid_amount;
    let previous_top_bidder = signer::address_of(&bidder);
    let new_bid_amount = 12;
    let coin = coin::mint<aptos_coin::AptosCoin>(new_bid_amount, &mint_cap);
    let balance_before = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&resource_account));
    coin::register<aptos_coin::AptosCoin>(&bidder);
    auction::bid(&second_bidder, coin);
    let balance_after = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&resource_account));
    assert!(balance_before + new_bid_amount - previous_top_bid == balance_after, EAUCTION_FAILED_07);
    assert!(coin::balance<aptos_coin::AptosCoin>(previous_top_bidder) == previous_top_bid, EAUCTION_FAILED_08);
    clean_up(burn_cap, mint_cap);
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, bidder = @0xb1d)]
  #[expected_failure(abort_code = auction::EAUCTION_IS_FINISHED)]
  fun auction_bid_is_finished(resource_account: signer, source_account: signer, aptos_framework: signer, bidder: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[signer::address_of(&bidder)]);
    let (burn_cap, mint_cap) = init_aptos_coin(&aptos_framework, &resource_account, &source_account);
    let new_bid_amount = 11;
    let coin = coin::mint<aptos_coin::AptosCoin>(new_bid_amount, &mint_cap);
    start_new_auction(&source_account, 10);
    auction::bid(&bidder, coin);
    timestamp::update_global_time_for_test_secs(15);
    auction::finalize_auction();
    let new_bid_amount = 12;
    let coin = coin::mint<aptos_coin::AptosCoin>(new_bid_amount, &mint_cap);
    auction::bid(&bidder, coin);
    clean_up(burn_cap, mint_cap);
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework)]
  #[expected_failure(abort_code = auction::EAUCTION_IS_FINISHED)]
  fun auction_finalize_already_finished(resource_account: signer, source_account: signer, aptos_framework: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[]);
    start_new_auction(&source_account, 10);
    timestamp::update_global_time_for_test_secs(15);
    auction::finalize_auction();
    auction::finalize_auction();
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework)]
  #[expected_failure(abort_code = auction::EAUCTION_IS_NOT_OVER_YET)]
  fun auction_finalize_not_over(resource_account: signer, source_account: signer, aptos_framework: signer) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[]);
    start_new_auction(&source_account, 10);
    auction::finalize_auction();
  }
  
  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework)]
  fun auction_finalize_success_no_bidders(resource_account: signer, source_account: signer, aptos_framework: signer,) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[]);
    let (burn_cap, mint_cap) = init_aptos_coin(&aptos_framework, &resource_account, &source_account);
    start_new_auction(&source_account, 10);
    let admin_balance_before = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&source_account));
    timestamp::update_global_time_for_test_secs(15);
    auction::finalize_auction();
    let admin_balance_after = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&source_account));
    assert!(admin_balance_before == admin_balance_after, EAUCTION_FAILED_09);
    // accept the token offer
    let token_id = auction::get_auction_token_id();
    //token_transfers::claim(&source_account, signer::address_of(&resource_account), token_id);
    assert!(token::balance_of(signer::address_of(&source_account), token_id) == 1, EAUCTION_FAILED_10);
    clean_up(burn_cap, mint_cap);
  }
  

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, bidder = @0xb1d)]
  fun auction_finalize_success_with_bidder(
    resource_account: signer,
    source_account: signer,
    aptos_framework: signer,
    bidder: signer
  ) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[signer::address_of(&bidder)]);
    let (burn_cap, mint_cap) = init_aptos_coin(&aptos_framework, &resource_account, &source_account);
    let new_bid_amount = 11;
    let coin = coin::mint<aptos_coin::AptosCoin>(new_bid_amount, &mint_cap);
    start_new_auction(&source_account, 10);
    auction::bid(&bidder, coin);
    timestamp::update_global_time_for_test_secs(15);
    let admin_balance_before = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&source_account));
    auction::finalize_auction();
    let admin_balance_after = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&source_account));
    assert!(admin_balance_before + new_bid_amount == admin_balance_after, EAUCTION_FAILED_11);
    // accept the token offer
    let token_id = auction::get_auction_token_id();
    //token_transfers::claim(&bidder, signer::address_of(&resource_account), token_id);
    assert!(token::balance_of(signer::address_of(&bidder), token_id) == 1, EAUCTION_FAILED_12);
    clean_up(burn_cap, mint_cap);
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, bidder = @0xb1d)]
  fun auction_accept_bid_success(
    resource_account: signer,
    source_account: signer,
    aptos_framework: signer,
    bidder: signer
  ) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[signer::address_of(&bidder)]);
    let (burn_cap, mint_cap) = init_aptos_coin(&aptos_framework, &resource_account, &source_account);
    let new_bid_amount = 11;
    let coin = coin::mint<aptos_coin::AptosCoin>(new_bid_amount, &mint_cap);
    start_new_auction(&source_account, 10);
    auction::bid(&bidder, coin);
    let admin_balance_before = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&source_account));
    auction::accept_bid_price(&source_account);
    let admin_balance_after = coin::balance<aptos_coin::AptosCoin>(signer::address_of(&source_account));
    assert!(admin_balance_before + new_bid_amount == admin_balance_after, EAUCTION_FAILED_11);
    clean_up(burn_cap, mint_cap);
  }

  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework)]
  #[expected_failure(abort_code = auction::EAUCTION_IS_NOT_OVER_YET)]
  fun auction_redeem_not_over(
    resource_account: signer,
    source_account: signer,
    aptos_framework: signer
  ) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[]);
    start_new_auction(&source_account, 10);
    auction::redeem_bottle(&source_account);
  }
  
  #[test(resource_account = @resource_account_addr, source_account = @source_addr, aptos_framework = @aptos_framework, bidder = @0xb1d)]
  fun auction_redeem_success(
    resource_account: signer,
    source_account: signer,
    aptos_framework: signer,
    bidder: signer
  ) {
    set_up_testing_environment(&resource_account, &source_account, &aptos_framework, vector<address>[signer::address_of(&bidder)]);
    //let (burn_cap, mint_cap) = init_aptos_coin(&aptos_framework, &resource_account, &source_account);
    //let new_bid_amount = 11;
    //let coin = coin::mint<aptos_coin::AptosCoin>(new_bid_amount, &mint_cap);
    //start_new_auction(&source_account, 10);
    //auction::bid(&bidder, coin);
    //auction::accept_bid_price(&source_account);
    //let token_id = auction::get_auction_token_id();
    //token_transfers::claim(&bidder, signer::address_of(&resource_account), token_id);
    //auction::redeem_bottle(&bidder);
    //assert!(auction::get_auction_status() == auction::get_auction_bottle_redeemed_status(), EAUCTION_FAILED_13);
    //clean_up(burn_cap, mint_cap);
  }
  */
  #[test]
  public fun printer() {
    print(&23);
    print(&string_utils::to_string(&utf8(b"Here")));
  }
}