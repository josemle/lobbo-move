#[allow(unused_use)]
module deploy_address::simple_coin {
    use std::string;
    use std::ascii;
    use std::option::{Self, Option};
    use sui::balance::{Self, Balance, Supply};
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::url::{Self, Url};
    use std::vector;

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

    public entry fun main<T>(ctx: &mut TxContext) {
        let coin = mint(44, ctx);
        let sender = tx_context::sender(ctx);
        transfer<T>(coin, sender);
    }
}