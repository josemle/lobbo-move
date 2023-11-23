module source_addr::simple_coin {
    
    use std::signer;

    struct Coin<phantom CoinType> has key {
        value: u64
    }

    struct MintCapability<phantom CoinType> has key {}

    public fun register<CoinType>(account: &signer) {
        let coin = Coin<CoinType> { value: 0 };
        move_to(account, coin);
    }

    public entry fun transfer<CoinType>(
        from: address,
        to: address,
        amount: u64,
    ) acquires Coin {
        let sender_coin = borrow_global_mut<Coin<CoinType>>(from);
        sender_coin.value = sender_coin.value - amount;
        
        let receiver_coin = borrow_global_mut<Coin<CoinType>>(to);
        receiver_coin.value = receiver_coin.value - amount;
    }

    public fun withdraw<CoinType> (
        from: &signer,
        amount: u64
    ): Coin<CoinType> acquires Coin {
        let account_addr = signer::address_of(from);
        let coin = borrow_global_mut<Coin<CoinType>>(account_addr);
        coin.value = coin.value - amount;
        Coin<CoinType> { value: amount }
    }

    public fun deposit<CoinType> (
        to: address,
        coin: Coin<CoinType>
    ) acquires Coin {
        let Coin<CoinType> { value } = coin;
        let coin = borrow_global_mut<Coin<CoinType>>(to);
        coin.value = coin.value + value;
    }

    public fun mint<CoinType>(account: &signer, amount: u64): Coin<CoinType> {
        let sender_addr = signer::address_of(account);
        assert!(exists<MintCapability<CoinType>>(sender_addr), 0);
        Coin<CoinType> { value: amount }
    }

    public fun initialize<CoinType>(account: &signer) {
        move_to(account, MintCapability<CoinType> {});
    }
}