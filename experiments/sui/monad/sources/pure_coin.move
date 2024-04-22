module deploy_address::pure_coin {

    use deploy_address::pure_balance::{Balance};

	public struct Coin<phantom T> has key, store {
        id: UID,
        balance: Balance<T>
    }

    // abbiamo un problema: il TxContext va passato per &mut e serve all'intera API: questo meccanismo è difficile da tradurre in codice puro
	public fun take<T>(bal: Balance<T>, value: u64, ctx: &mut TxContext): (Coin<T>, Balance<T>) {
        let (new, modified) = bal.split(value);
        let coin = Coin {            
            id: object::new(ctx),
            balance: new
        };
        (coin, modified)
    }

    public fun put<T>(bal: Balance<T>, coin: Coin<T>): Balance<T> {
        let Coin { id, balance } = coin;
        id.delete();    // bisogna continuamente distruggere i coin in questa versione pura
        bal.join(balance)
    }


    public fun join<T>(c1: Coin<T>, c2: Coin<T>, ctx: &mut TxContext): Coin<T> {
        let Coin { id: id1, balance: bal1 } = c1;
        let Coin { id: id2, balance: bal2 } = c2;
        id1.delete();
        id2.delete();
        Coin { id: object::new(ctx), balance: bal1.join(bal2) } // e bisogna crearne sempre di nuovi
    }

    public fun split<T>(c: Coin<T>, amt: u64, ctx: &mut TxContext): (Coin<T>, Coin<T>) {
        let Coin { id, balance } = c;
        id.delete();
        let (r, bal) = take(balance, amt, ctx);
        (r, Coin { id: object::new(ctx), balance: bal })
    }
	
}
