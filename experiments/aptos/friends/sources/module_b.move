module deploy_address::module_b {

    use deploy_address::module_a::{A, Self};

    struct B {
        val: u64
    }

    public fun set_B(obj: &mut B, b: u64) {
        obj.val = b;
    }
    


}