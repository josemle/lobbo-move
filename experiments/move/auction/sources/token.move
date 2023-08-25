module resource_account_addr::token {
  use aptos_token::token;
  use std::bcs;
  use std::string::{Self, String};

  friend resource_account_addr::auction;
  friend resource_account_addr::auction_simple;
  #[test_only]
  friend resource_account_addr::tests;

  fun init_module(account: &signer) {
    let description = string::utf8(b"NFTs");
    let collection_uri = string::utf8(b"www.example.com/collection-metadata.json");
    let maximum_supply = 0;
    let collection_mutate_settings = vector<bool>[ false, false, false ];
    token::create_collection(account, get_collection_name(), description, collection_uri, maximum_supply, collection_mutate_settings);
  }

  public(friend) fun mint(
    token_name: String,
    token_description: String,
    token_metadata_uri: String
  ): token::TokenId {
    let resource_account_signer = resource_account_addr::access_control::get_signer();
    let token_mutate_settings = vector<bool>[false, false, false, false, false];
    let token_mutability_config = token::create_token_mutability_config(&token_mutate_settings);
    let token_data_id = token::create_tokendata(
      &resource_account_signer,
      get_collection_name(), 
      token_name,
      token_description,
      // disable token balance tracking to avoid deletion of token data when burning
      0,
      token_metadata_uri,
      // royalty payee
      @resource_account_addr,
      // royalty points denominator
      0,
      // royalty points numerator
      0,
      token_mutability_config,
      //                predefined constant from the aptos_token::token module
      vector<String>[string::utf8(b"TOKEN_BURNABLE_BY_CREATOR")],
      vector<vector<u8>>[bcs::to_bytes<bool>(&true)],
      vector<String>[string::utf8(b"bool")],
    );
    let token_id = token::mint_token(&resource_account_signer, token_data_id, 1);
    token_id
  }

  public(friend) fun burn(token_id: &token::TokenId, owner: address, amount: u64) {
    let resource_account_signer = resource_account_addr::access_control::get_signer();
    let (_, collection_name, token_name, property_version) = token::get_token_id_fields(token_id);
    token::burn_by_creator(&resource_account_signer, owner, collection_name, token_name, property_version, amount);
  }

  #[view]
  public fun get_collection_name(): String {
    string::utf8(b"Auction")
  }

  #[test_only]
  public fun init_module_test(account: &signer) {
    init_module(account);
  }
}