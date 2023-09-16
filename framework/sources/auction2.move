module move4algo_framework::auction2 {

use move4algo_framework::transaction;

struct Asset has store {
  id: u64,
  amount: u64,
  owner: address
}

struct Auction has key {
  owner: address,
  top_bid: Asset,
  deadline: u64
}


public fun get_id(asset: &Asset): u64 {
  asset.id
}

public fun get_amount(asset: &Asset): u64 {
  asset.id
}

public fun get_owner(asset: &Asset): address { 
   asset.owner
}

public fun transfer(asset: &Asset, receiver: address) {
    let id = get_id(asset);
    let amount = get_amount(asset);
    let owner = get_owner(asset);
		transaction::transfer_asset(id, amount, owner, receiver);
}



/*public fun bid(addr: address, assets: Asset) acquires Auction {
  let auction = borrow_global_mut<Auction>(addr);
  transfer(auction.top_bid, get_owner(&auction.top_bid));
  auction.top_bid = assets;
}*/

public fun bid2(addr: address, assets: Asset) acquires Auction {
  let auction = borrow_global_mut<Auction>(addr);
  transfer(&auction.top_bid, get_owner(&auction.top_bid));
  let auction =
    Auction {
        owner: auction.owner,
        top_bid: assets,
        deadline: auction.deadline };
  opcode::app_global_put_struct(address::as_signer(addr), auction)
}


}
