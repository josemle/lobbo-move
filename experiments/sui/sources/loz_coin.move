module deploy_address::loz_coin {
    use sui::tx_context::{Self, TxContext};
    use deploy_address::simple_coin::{Self};
    #[test_only]
    use sui::test_scenario;

    struct LOZCOIN has drop {}

    fun init(ctx: &mut TxContext) {
        mint(1000, tx_context::sender(ctx), ctx);
    }

    public entry fun mint(amount:u64, recipient: address, ctx: &mut TxContext) {
        let coins = simple_coin::mint<LOZCOIN>(amount, ctx);
        simple_coin::transfer<LOZCOIN>(coins, recipient);
    }

    public entry fun transfer(coins: Coin<LOZCOIN>, recipient: address, ctx: &mut TxContext) {
        simple_coin::transfer<LOZCOIN>(coins, recipient);
    }

    #[test]
    public fun test_mint() {
        let user = @0xA;
        let receiver = @0xB;
        let num_coins = 10;

        let scenario_val = test_scenario::begin(user);
        let scenario = &mut scenario_val;
        {
            let ctx = test_scenario::ctx(scenario);
            init(ctx)
        };

        test_scenario::next_tx(scenario, user);
        {
            mint(num_coins, receiver, test_scenario::ctx(scenario));
        };

        test_scenario::end(scenario_val);
    }
}