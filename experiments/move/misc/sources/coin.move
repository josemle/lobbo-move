module deploy_address::coin {
    
    struct Coin<phantom CoinType> has key {
        value: u64
    }

    public entry fun transfer<CoinType> (
        from: address,
        to: address,
        amount: u64,
    ) acquires Coin {
        let coin = withdraw<CoinType>(from, amount);
        deposit(to, coin);
    }

    public entry fun transfer2<CoinType>(
        from: address,
        to: address,
        amount: u64,
    ) acquires Coin {
        let from_coin = borrow_global_mut<Coin<CoinType>>(from);
        from_coin.value = from_coin.value - amount;
        let to_coin = borrow_global_mut<Coin<CoinType>>(to);
        to_coin.value = to_coin.value - amount;
    }

    public fun withdraw<CoinType> (
        from: address,
        amount: u64
    ): Coin<CoinType> acquires Coin {
        let coin = borrow_global_mut<Coin<CoinType>>(from);
        coin.value = coin.value - amount;
        Coin<CoinType> { value: amount }
    }

    public fun deposit<CoinType> (
        to: address,
        coin: Coin<CoinType>
    ) acquires Coin {
        let Coin<CoinType> { value } = coin;
        let dest_coin = borrow_global_mut<Coin<CoinType>>(to);
        dest_coin.value = dest_coin.value + value;
    }

    public entry fun opt_in<CoinType>(account: &signer) {
        move_to(account, Coin<CoinType> { value: 0 });
    }
}