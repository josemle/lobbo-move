module deploy_address::pure_balance {

    const ENotEnough: u64 = 2;

	public struct Balance<phantom T> has store {
        value: u64
    }

    public fun zero<T>(): Balance<T> {
        Balance { value: 0 }
    }

    public fun join<T>(bal1: Balance<T>, bal2: Balance<T>): Balance<T> {
        let Balance { value: v1 } = bal1;   // bisogna distruggere sempre tutto, prima di ricreare
        let Balance { value: v2 } = bal2;
        Balance { value: v1 + v2 }
    }

    public fun split<T>(bal: Balance<T>, amt: u64): (Balance<T>, Balance<T>) {  // il secondo è il balance modificato, come si fa da tradizione nella state monad
        assert!(bal.value >= amt, ENotEnough);
        let Balance { value } = bal;
        (Balance { value: amt }, Balance { value: value - amt })
    }

    public fun create<T>(value: u64): Balance<T> {
        Balance<T> { value }
    }

}
