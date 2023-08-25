module deploy_address::abilities3 {
	
	struct Coin has store {
        value: u64
    }

	struct Caz has key {
		coin: Coin
	}

    public fun mint(value: u64): Coin {
        // You would want to gate this function with some form of access control to prevent
        // anyone using this module from minting an infinite amount of coins.
        Coin { value }
    }

    public fun withdraw(coin: &mut Coin, amount: u64): Coin {
        assert!(coin.value >= amount, 1000);
        coin.value = coin.value - amount;
        Coin { value: amount }
    }

    public fun deposit(coin: &mut Coin, other: Coin) {
        let Coin { value } = other;
        coin.value = coin.value + value;
    }

    public fun split(coin: Coin, amount: u64): (Coin, Coin) {
        let other = withdraw(&mut coin, amount);
        (coin, other)
    }

    public fun merge(coin1: Coin, coin2: Coin): Coin {
        deposit(&mut coin1, coin2);
        coin1
    }

    public fun destroy_zero(coin: Coin) {
        let Coin { value } = coin;
        assert!(value == 0, 1001);
    }

	public fun main(acc: &signer) {
		let c1 = mint(1000);
		move_to(acc, Caz { coin: c1 });
	}


}
