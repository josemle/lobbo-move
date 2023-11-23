module resource_account_addr::auction_simple {
    use aptos_framework::timestamp;
    use aptos_framework::signer;
    use aptos_framework::aptos_coin;
    use aptos_framework::coin;
    use aptos_framework::account;
    use aptos_framework::resource_account;


    struct OracleBet has key {
        player1: address,
        player2: address,
        oracle: address,
        stake: u64,
        deadline: u64,
    }

    struct ResourceAccountCap has key {
        resource_acc_cap: account::SignerCapability
    }

    struct BetP1<phantom CoinType> has key {
        value: Coin<CoinType>
    }

    struct BetP2<phantom CoinType> has key {
        value: Coin<CoinType>
    }

    fun init_module(account: &signer) {
        let resource_acc_cap = resource_account::retrieve_resource_account_cap(account, signer::address_of(account));
        move_to(
            account,
            ResourceAccountCap {
                resource_acc_cap
            }
        );
    }

    public entry fun initBet() acquires ResourceAccountCap {
        let resource_account_signer = get_signer();
        let oracleBet = OracleBet {
            player1,
            player2,
            oracle,
            stake,
            deadline
        };
        move_to(resource_account_signer, oracleBet)
    }

    public fun join(better: &signer, bet: Coin<CoinType>) acquires OracleBet, ResourceAccountCap {
        let oracleBet = borrow_global_mut<OracleBet>(@resource_account_addr);
        assert!(address_of(better) == oracleBet.player1 || address_of(better) == oracleBet.player2, 0);
        assert!(coin::value<CoinType>(&bet) == oracleBet.stake, 0);
        let resource_account_signer = get_signer();
        if(!exists<BetP1<CoinType>>(resource_account_address) && address_of(better) == oracleBet.player1) {
            let bet_p1 = BetP1 { value: bet };
            move_to(resource_account_signer, bet_p1)
        } else if(!exists<BetP1<CoinType>>(resource_account_address) && address_of(better) == oracleBet.player2) {
            let bet_p2 = BetP2 { value: bet };
            move_to(resource_account_signer, bet_p2)
        }
    }

    public fun winner<CoinType>(oracle: &signer, winner: address) acquires OracleBet, Bet {
        assert!(exists<OracleBet>(@resource_account_addr), 0);
        let OracleBet {
            player1,
            player2,
            oracle: oracle_address,
            stake: _,
            deadline: _
        } = move_from<OracleBet>(@resource_account_addr);
        
        assert!(address_of(oracle) == oracle_address, 0);
        assert!(winner == player1 || winner == player2, 0);
        let BetP1 { value: bet1 } = move_from<BetP1<CoinType>>(player1);
        let BetP2 { value: bet2 } = move_from<BetP2<CoinType>>(player2);
        coin::merge(&mut bet1,bet2);
        coin::deposit(winner, bet1 );
    }

    fun get_signer(): signer acquires ResourceAccountCap {
        let resource_signer = account::create_signer_with_capability(
            &borrow_global<ResourceAccountCap>(@resource_account_addr).resource_signer_cap
        );
        resource_signer
    }
}