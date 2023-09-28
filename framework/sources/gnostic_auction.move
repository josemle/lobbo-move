module move4algo_framework::gnostic_auction {

  use move4algo_framework::opcode;

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

  const AUCTION_NAME: vector<u8> = b"MyAuction";

  public entry fun start_auction<AssetType>(base: Asset<AssetType>) {
    let sender = opcode::txn_Sender();
    let auction = Auction<AssetType> {
      owner: sender,
      top_bid: base,
      top_bidder: sender,
      expired: false
    };
    opcode::app_global_put_struct(AUCTION_NAME, auction);
  }

  public fun bid<AssetType>(assets: Asset<AssetType>) {
    let auction = opcode::app_global_get_struct<Auction<AssetType>>(AUCTION_NAME);
    let Auction{ owner, top_bid, top_bidder, expired } = auction;
    assert!(!expired, 0);
    assert!(get_amount(&assets) > get_amount(&top_bid), 1);
    transfer(top_bid, top_bidder);
    transfer(assets, opcode::global_CurrentApplicationAddress());
    let new_auction = Auction { owner, top_bid: assets, top_bidder: opcode::txn_Sender(), expired};
    opcode::app_global_put_struct(AUCTION_NAME, new_auction);
  }

  public entry fun finalize_auction<AssetType>() {
    let auction = opcode::app_global_get_struct<Auction<AssetType>>(AUCTION_NAME);
    let Auction{ owner, top_bid, top_bidder, expired } = auction;
    transfer(top_bid, owner);
  }

  public fun transfer<AssetType>(a: Asset<AssetType>, to: address){
    let Asset { id, amount, owner } = a;
  }

  public fun get_owner<AssetType>(a: &Asset<AssetType>) : address{
    @0x1
  }

  public fun get_amount<AssetType>(a: &Asset<AssetType>) : u64 { 0 }


}
