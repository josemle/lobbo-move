module deploy_address::simple {

    struct Simple has key {
        a: u64,
        b: bool
    }
  
    public fun f(acc: signer, n: u64) {
        let s = Simple { 
            a: n+7,
            b: true 
        };
        move_to(&acc, s);
    }

    public fun g(acc: signer) {
        let s = 58;   
        f(acc, h(s));
    }

    public fun h(n: u64): u64 {
        return n + 18
    }
}