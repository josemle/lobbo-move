#[allow(unused_use)]
module deploy_address::simple_object {
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    
    struct Simple has key {
        id: UID,
        field: u64,
    }

    public fun set_field(s: &mut Simple, v: u64) {
        s.field = v
    }

    public fun get_field(s: &Simple): u64 {
        s.field
    }
    
    public fun transfer(s: Simple, recipient: address) {
        transfer::transfer(s, recipient)
    }

    public fun create(ctx: &mut TxContext): Simple {
        Simple {
            id: object::new(ctx),
            field: 0,
        }
    }

    public entry fun main(ctx: &mut TxContext) {
        let s = create(ctx);
        set_field(&mut s, 44);
        let sender = tx_context::sender(ctx);
        transfer(s, sender);
    }
}
