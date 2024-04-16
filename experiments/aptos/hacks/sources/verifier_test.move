module deploy_address::verifier_test {

    struct Stocazzo has drop {
        x: u8
    }

    public fun f(s: Stocazzo): Stocazzo {
        s
    }

    public entry fun main() {
        let s = Stocazzo { x: 0xaa };
        f(s);
    }
}