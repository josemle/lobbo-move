module deploy_address::simple_coin {
    use sui::tx_context::{TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;

    struct Coin<phantom T> has key, store {
        id: UID,
        balance: u64
    }

    public fun mint<T>(value: u64, ctx: &mut TxContext): Coin<T> {
        Coin {
            id: object::new(ctx),
            balance: value
        }
    }

    public fun transfer<T>(coin: Coin<T>, to: address) {
        transfer::transfer(coin, to);
    }
}