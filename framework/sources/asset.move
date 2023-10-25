module algomove::asset {

	use algomove::opcode as op;
	use algomove::transaction as txn;
	use std::string::{String};

	struct Handle<phantom AssetType> has copy, drop {
		id: u64,
		owner: address
	}

	struct Asset<phantom AssetType> {
		id: u64,
		amount: u64,
		owner: address
	}
	
	public fun create<AssetType>(
		sender: address,
		total: u64, 
		decimals: u64, 
		default_frozen: bool,
		name: String,
		short_name: String
	): Asset<AssetType> {
		txn::init_asset_config(sender, total, decimals, default_frozen);
		op::itxn_field_Name(name);
		op::itxn_field_UnitName(short_name);
		txn::submit();
		Asset<AssetType> { id: op::txn_CreatedAssetID(), amount: total, owner: sender }
	}

	public fun transfer<AssetType>(
		receiver: address, 
		asset: Asset<AssetType>, 
		amount: u64
	): Asset<AssetType> {
		let Asset { id, amount: old_amount, owner } = asset;
		txn::asset_transfer(id, amount, owner, receiver);
		Asset<AssetType> { id, amount: old_amount - amount, owner }
	}

	public fun release<AssetType>(asset: Asset<AssetType>): Handle<AssetType> {
		let Asset { id, amount: _amount, owner } = asset;
		Handle { id, owner }
	}

	public fun acquire<AssetType>(h: Handle<AssetType>): Asset<AssetType> {
		Asset<AssetType> { id: h.id, amount: op::asset_holding_get_AssetBalance(h.owner, h.id), owner: h.owner }
	}

	public fun retrieve_by_id<AssetType>(
		id: u64,
		owner: address
	): Asset<AssetType> {
		acquire(Handle { id, owner })
	}

	public fun get_id<AssetType>(asset: &Asset<AssetType>): u64 {
		asset.id
	}

	public fun get_owner<AssetType>(asset: &Asset<AssetType>): address {
		asset.owner
	}

}
