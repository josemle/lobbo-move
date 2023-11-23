module deploy_address::example2 {
    
    struct A has key {
        val: u64
    }

    public fun move_vector(acc: &signer, acc2: &signer, a: A) {
        if (true) {
            move_to(acc, a);
        }
        else {
            move_to(acc2, a);
        };

    }

    public fun double_borrow(acc: address) acquires A {
        let a = borrow_global_mut<A>(acc);
        let b = borrow_global_mut<A>(acc);
    }

    public fun double_move_from(acc: address) acquires A {
        let A { val } = move_from<A>(acc);
        let A { val } = move_from<A>(acc);
    }

}