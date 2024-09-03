module rosetta_smart_contracts::payment_splitter {
    use std::vector;

    struct PaymentSplitter<phantom CoinType> has key {
        totalShares: u64,
        totalReleased: u64,
        payees: vector<address>
    }
}