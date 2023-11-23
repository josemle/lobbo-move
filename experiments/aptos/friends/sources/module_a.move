module deploy_address::module_a {
    //friend deploy_address::module_b;
    use deploy_address::module_b::{B, Self};
    
    struct A {
        val: u64
    }

    struct C has key {
        val: vector<u64>
    }

    public fun get(obj: &A) : u64 {
        obj.val
    }

    public fun set_A(obj: &mut A, a: u64) {
        obj.val = a;
    }

    public fun get_val() : u64 {
        return 8
    }

    public fun move_vector(acc: &signer, c: C) {
        move_to(acc, c);
    }

}