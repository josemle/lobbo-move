module algomove::asset {

	use algomove::opcode as op;
	use algomove::transaction as txn;
	use std::string::{String};

	struct Asset<phantom AssetType> has store {
		id: u64,
		amount: u64,
		owner: address
	}
	
	public fun create<AssetType>(acc: &signer, total: u64, decimals: u64, default_frozen: bool, short_name: String): Asset<AssetType> {
		let sender = txn::address_of_signer(acc);
		txn::init_asset_config(sender, total, decimals, default_frozen);
		op::itxn_field_Name(txn::name_of<AssetType>());
		op::itxn_field_UnitName(short_name);
		op::itxn_submit();
		Asset<AssetType> { id: op::txn_CreatedAssetID(), amount: total, owner: sender }
	}

	public fun deposit<AssetType>(receiver: address, assets: Asset<AssetType>) {
		let Asset { id, amount, owner:_ } = assets;
		txn::asset_transfer(op::txn_Sender(), id, amount, receiver)
	}

	public fun withdraw<AssetType>(acc: &signer, amount: u64): Asset<AssetType> {
		let id = txn::retrieve_asset_id<AssetType>();
		let sender = txn::address_of_signer(acc);
		assert!(amount <= op::asset_holding_get_AssetBalance(sender, id), 1);
		Asset<AssetType> { id, amount, owner: sender }
	}

	public fun transfer<AssetType>(from: &signer, to: address, amount: u64) {
        let assets = withdraw<AssetType>(from, amount);
        deposit(to, assets);
    }

	public fun split<AssetType>(assets: Asset<AssetType>, amt: u64): (Asset<AssetType>, Asset<AssetType>) {
		let Asset { id, amount: old_amount, owner } = assets;
		let new = Asset<AssetType> { id, amount: old_amount - amt, owner };
		let old = Asset<AssetType> { id, amount: old_amount, owner };
		(new, old)
	}

	/*public fun get_id<AssetType>(asset: &Asset<AssetType>): u64 {
		asset.id
	}

	public fun get_owner<AssetType>(asset: &Asset<AssetType>): address {
		asset.owner
	}*/

	public fun value<AssetType>(asset: &Asset<AssetType>): u64 {
		asset.amount
	}

}
