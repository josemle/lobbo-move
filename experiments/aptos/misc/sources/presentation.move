module deploy_address::presentation {

    struct S has key {
        a: u64
    }
    /*

    public fun foo(acc: &signer) {
        let s1 = S{ a: 1 };
        increment(s1); // Error: s2 can not be dropped!
        s1.a; // Error: s1 hab been moved!
        savetoBlockchain(acc, s1);
    }

    public fun increment(s: S) {
        s.a = s.a + 1;
    }

    public fun savetoBlockchain(acc: &signer, s: S) {
        move_to(acc, s);
    }
    */
}