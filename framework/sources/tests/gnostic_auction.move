module algomove::gnostic_auction {

  use algomove::opcode;
  use algomove::algos;
  use algomove::transaction::{get_sender};
  use algomove::asset::{Self, Asset};

  // auction status codes
  const AUCTION_LIVE: u64 = 1;
  const AUCTION_FINISHED: u64 = 2;

  // error codes
  const EAUCTION_IS_NOT_OVER_YET: u64 = 0;
  const EASSET_OWNER_IS_NOT_SENDER: u64 = 1;

  // other constants
  const AUCTION_GLOBAL_STORAGE_KEY: vector<u8> = b"Auction";

  struct Auction has key, drop {
    status: u64,
    owner: address,
    top_bid: u64,
    top_bidder: address,
    deadline: u64
  }

  fun get_state(): Auction {
    opcode::app_global_get<Auction>(AUCTION_GLOBAL_STORAGE_KEY)
  }

  fun set_state(a: Auction) {
    opcode::app_global_put<Auction>(AUCTION_GLOBAL_STORAGE_KEY, a)
  }

  public entry fun start_auction(
    deadline: u64,
    starting_price: u64,
  ) {
    let sender = get_sender();
    let auction = Auction {
      status: AUCTION_LIVE,
      owner: sender,
      top_bid: starting_price,
      top_bidder: sender,
      deadline
    };
    set_state(auction);
  }

  // asta con algos

  public fun bid_algos(
    amount: u64
  ) {
		// TODO: riprendere il filo da qua: la app_global_get non deve ritornare copie
		// forse e' meglio che facciamo 10 primitive, 5 local e 5 global, e riscriviamo questa asta con le move_to_global e le borrow ecc
    let auction = get_state();
    let app = opcode::global_CurrentApplicationAddress();
    let sender = get_sender();
    algos::transfer(sender, app, amount);	// paga il nuovo bid
    algos::transfer(app, auction.top_bidder, auction.top_bid);	// restituisce i soldi al vecchio bidder
    auction.top_bid = amount;
    auction.top_bidder = sender;
    set_state(auction);
  }

  public entry fun finalize_auction() {
    let auction = get_state();
    assert!(opcode::global_LatestTimestamp() > auction.deadline, EAUCTION_IS_NOT_OVER_YET);
    auction.status = AUCTION_FINISHED;
    algos::transfer(opcode::global_CurrentApplicationAddress(), auction.owner, auction.top_bid)
  }

	// asta con asset

  public fun bid_asset<AssetType>(
    asset: Asset<AssetType>,
    amount: u64
  ): Asset<AssetType> {
    let auction = get_state();
    let app = opcode::global_CurrentApplicationAddress();
		let sender = get_sender();
		let id = asset::get_id(&asset);
		assert!(sender == asset::get_owner(&asset), EASSET_OWNER_IS_NOT_SENDER);
    let new_bidder_asset = asset::transfer(app, asset, amount);
    let old_bidder_asset = asset::retrieve_by_id<AssetType>(id, app);
    let old_bidder_asset = asset::transfer(auction.top_bidder, old_bidder_asset, auction.top_bid);
    let _ = asset::release(old_bidder_asset);	
    auction.top_bid = amount;
    auction.top_bidder = sender;
    new_bidder_asset
  }



}
