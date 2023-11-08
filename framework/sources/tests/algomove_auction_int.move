module algomove::algomove_auction_int {

  use algomove::opcode;
  use algomove::transaction;

  // module asset

  struct AssetID<phantom AssetType> has store, copy, drop {
    value: u64
  }

	struct Asset<phantom AssetType> has key {
		id: AssetID<AssetType>,
    amount: u64,
    owner: address
	}

  struct Auction<phantom AssetType> has key {
    id: AssetID<AssetType>,
    auctioneer: address,
    top_bid: u64,
    top_bidder: address,
  }

  public fun get_amount<AssetType>(a: &Asset<AssetType>) : u64 { 
    a.amount
  }

  public fun get_id<AssetType>(a: &Asset<AssetType>) : AssetID<AssetType> { 
    a.id
  }

  public fun split<AssetType>(a: Asset<AssetType>, amount: u64): (Asset<AssetType>, Asset<AssetType>) {
    let Asset { id, amount: old_amount, owner } = a;
    (Asset { id, amount, owner }, Asset { id, owner, amount: old_amount - amount })
  }

  public fun withdraw<AssetType>(id: AssetID<AssetType>, from: address, amount: u64): Asset<AssetType> {
    Asset<AssetType> { id, amount: amount, owner: from }
  }

  public fun deposit<AssetType>(a: Asset<AssetType>, to: address) {
    let Asset { id, amount, owner } = a;
    transaction::asset_transfer(id.value, amount, owner, to);
  }

  public fun transfer<AssetType>(id: AssetID<AssetType>, from: address, to: address, amount: u64){
		let asset = withdraw(id, from, amount);
    deposit(asset, to);
  }


  // module auction

  const AUCTION_NAME: vector<u8> = b"MyAuction";

  public fun start_auction<AssetType>(id: AssetID<AssetType>, base: u64) {
    let sender = opcode::txn_Sender();
    let auction = Auction<AssetType> {
      id,
      auctioneer: sender,
      top_bid: base,
      top_bidder: sender,
    };
    opcode::app_global_put(AUCTION_NAME, auction);
  }

  public fun bid<AssetType>(assets: Asset<AssetType>) {
    let auction = opcode::app_global_get<Auction<AssetType>>(AUCTION_NAME);
    let Auction { id, auctioneer, top_bid, top_bidder } = auction;
    assert!(get_amount(&assets) > top_bid, 1);
    let sender = transaction::get_sender();
    let app = opcode::global_CurrentApplicationAddress();

    // restistuisco i soldi al vecchio bidder
    let old_bid = withdraw(id, app, top_bid);
    deposit(old_bid, top_bidder);

    // deposito il nuovo bid sul conto del contratto
    let new_auction = Auction<AssetType> { id, auctioneer, top_bid: get_amount(&assets), top_bidder: sender };
    deposit(assets, app);

    opcode::app_global_put(AUCTION_NAME, new_auction);
  }

  public entry fun finalize_auction<AssetType>() {
    let auction = opcode::app_global_get<Auction<AssetType>>(AUCTION_NAME);
    let Auction { id, auctioneer, top_bid, top_bidder: _ } = auction;
    let app = opcode::global_CurrentApplicationAddress();
    transfer(id, app, auctioneer, top_bid);
  }


}
