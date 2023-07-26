module move4algo_framework::asset {

	use move4algo_framework::opcode;
	use move4algo_framework::transaction;
	use std::string::{String};

	struct AssetID<phantom AssetType> has copy, drop {
		value: u64
	}

	struct Asset<phantom AssetType> {
		id: AssetID<AssetType>,
		amount: u64
	}
	
	public fun create<AssetType>(
		total: u64, 
		decimals: u64, 
		default_frozen: bool,
		name: String,
		short_name: String
	): Asset<AssetType> {
		transaction::init_config_asset(transaction::get_sender(), total, decimals, default_frozen);
		opcode::itxn_field_config_asset_Name(name);
		opcode::itxn_field_config_asset_UnitName(short_name);
		transaction::submit();
		Asset<AssetType> { id: AssetID { value: opcode::txn_CreatedAssetID() }, amount: total }
	}

	public fun transfer<AssetType>(
		receiver: address, 
		asset: Asset<AssetType>, 
		amount: u64
	): Asset<AssetType> {
		let Asset { id, amount: old_amount } = asset;
		transaction::transfer_asset(id.value, amount, transaction::get_sender(), receiver);
		Asset<AssetType> { id, amount: old_amount - amount }
	}

	public fun release<AssetType>(asset: Asset<AssetType>): AssetID<AssetType> {
		let Asset { id, amount: _amount } = asset;
		id
	}

	public fun acquire<AssetType>(id: AssetID<AssetType>): Asset<AssetType> {
		Asset<AssetType> { id, amount: opcode::asset_holding_get_AssetBalance(transaction::get_sender()) }
	}

	// alternativa con side-effect, ma si perdono i linear type impliciti nell'uso del CPS (continuation passing style)

	public fun transfer2<AssetType>(
		receiver: address, 
		asset: &mut Asset<AssetType>, 
		amount: u64
	) {
		transaction::transfer_asset(asset.id.value, amount, transaction::get_sender(), receiver);
		asset.amount = asset.amount - amount;
	}

}
