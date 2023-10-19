module move4algo_framework::gnostic_auction_standalone_paper {

  use move4algo_framework::opcode;
  use move4algo_framework::transaction;

  // module asset

	struct Asset<phantom AssetType> has store {
		id: u64,
		amount: u64,
	}

  struct Auction<phantom AssetType> has key {
    owner: address,
    top_bid: Asset<AssetType>,
    top_bidder: address,
    expired: bool
  }

  public fun split<AssetType>(a: Asset<AssetType>, amount: u64): (Asset<AssetType>, Asset<AssetType>) {
    let Asset { id, amount: old_amount } = a;
    (Asset { id, amount }, Asset { id, amount: old_amount - amount })
  }

  public fun transfer<AssetType>(a: &Asset<AssetType>, from: address, to: address){
		transaction::asset_transfer(a.id, a.amount, from, to);
  }

  public fun get_amount<AssetType>(a: &Asset<AssetType>) : u64 { 
    a.amount
  }


  // module auction

  const AUCTION_NAME: vector<u8> = b"MyAuction";

  public fun start_auction<AssetType>(base: Asset<AssetType>) {
    let sender = opcode::txn_Sender();
    let auction = Auction<AssetType> {
      owner: sender,
      top_bid: base,
      top_bidder: sender,
      expired: false
    };
    opcode::app_global_put(AUCTION_NAME, auction);
  }

  public fun bid<AssetType>(assets: Asset<AssetType>) {
    let auction = opcode::app_global_get<Auction<AssetType>>(AUCTION_NAME);
    let Auction { owner, top_bid, top_bidder, expired } = auction;
    assert!(!expired, 0);
    assert!(get_amount(&assets) > get_amount(&top_bid), 1);
    let sender = transaction::get_sender();
    let app = opcode::global_CurrentApplicationAddress();
    transfer(&top_bid, app, top_bidder); // restituisco i soldi al top bidder
    transfer(&assets, sender, app);
    let new_auction = Auction { owner, top_bid: assets, top_bidder: sender, expired };
    opcode::app_global_put(AUCTION_NAME, new_auction);
  }

  public entry fun finalize_auction<AssetType>() {
    let auction = opcode::app_global_get<Auction<AssetType>>(AUCTION_NAME);
    let Auction { owner, top_bid, top_bidder, expired } = auction;
    let app = opcode::global_CurrentApplicationAddress();
    transfer(&top_bid, app, owner);
  }


}
