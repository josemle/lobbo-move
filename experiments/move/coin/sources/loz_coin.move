module source_addr::loz_coin {

    use source_addr::coin::{Self};
    use std::signer;

    struct LozCoin has key {}

    public entry fun createCoin(account: &signer, amount: u64) {
        coin::initialize<LozCoin>(account);
        coin::register<LozCoin>(account);
        mint(account, amount);
    }

    public entry fun mint(account: &signer, amount: u64) {
        let coins = coin::mint<LozCoin>(account, amount);
        let sender_addr = signer::address_of(account);
        coin::deposit<LozCoin>(sender_addr, coins);
    }

    public entry fun transfer(sender: &signer, receiver: address, amount: u64) {
        coin::transfer<LozCoin>(sender, receiver, amount);
    }
}