module algomove::algomove_auction_paper {

  use algomove::opcode;
  use algomove::transaction as txn;

  // module asset

  struct AssetID<phantom AssetType> has store, copy, drop {
    value: u64
  }

	struct Asset<phantom AssetType> has store {
		id: AssetID<AssetType>,
    amount: u64,
    owner: address
	}

  struct Auction<phantom AssetType> has key {
    auctioneer: address,
    top_bid: Asset<AssetType>,
    top_bidder: address,
  }

  public fun get_amount<AssetType>(a: &Asset<AssetType>) : u64 { 
    a.amount
  }

  public fun deposit<AssetType>(a: Asset<AssetType>, to: address) {
    let Asset { id, amount, owner } = a;
    txn::asset_transfer(id.value, amount, owner, to);
  }

  /*public fun get_id<AssetType>(a: &Asset<AssetType>) : AssetID<AssetType> { 
    a.id
  }

  public fun split<AssetType>(a: Asset<AssetType>, amount: u64): (Asset<AssetType>, Asset<AssetType>) {
    let Asset { id, amount: old_amount, owner } = a;
    (Asset { id, amount, owner }, Asset { id, owner, amount: old_amount - amount })
  }

  public fun withdraw<AssetType>(id: AssetID<AssetType>, from: address, amount: u64): Asset<AssetType> {
    Asset<AssetType> { id, amount: amount, owner: from }
  }

  public fun transfer<AssetType>(id: AssetID<AssetType>, from: address, to: address, amount: u64){
		let asset = withdraw(id, from, amount);
    deposit(asset, to);
  }*/

  // module auction

  public fun start_auction<AssetType>(base: Asset<AssetType>) {
    let sender = txn::get_sender();
    let auction = Auction<AssetType> {
      auctioneer: sender,
      top_bid: base,
      top_bidder: sender,
    };
    opcode::app_global_put(txn::bytes_of_address(sender), auction);
  }

  public fun bid<AssetType>(auctioneer: address, assets: Asset<AssetType>) {
    let Auction { auctioneer, top_bid, top_bidder } = opcode::app_global_get<Auction<AssetType>>(txn::bytes_of_address(auctioneer));
    assert!(get_amount(&assets) > get_amount(&top_bid), 1);
    let sender = txn::get_sender();
    deposit(top_bid, top_bidder);
    let new_auction = Auction<AssetType> { auctioneer, top_bid: assets, top_bidder: sender };
    opcode::app_global_put(txn::bytes_of_address(auctioneer), new_auction);
  }

  public fun finalize_auction<AssetType>() {
    let sender = txn::get_sender();
    let auction = opcode::app_global_get<Auction<AssetType>>(txn::bytes_of_address(sender));
    assert!(sender == auction.auctioneer, 2);
    let Auction { auctioneer, top_bid, top_bidder: _ } = auction;
    deposit(top_bid, auctioneer);
  }

}