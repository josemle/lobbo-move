module deploy_address::payment_splitter {
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::signer;
    use aptos_framework::event;
    use std::vector;

    struct PaymentSplitter<phantom CoinType> has key {
        totalShares: u64,
        totalReleased: u64,
        payees: vector<address>
    }
}