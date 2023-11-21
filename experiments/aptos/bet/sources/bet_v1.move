module deploy_address::bet_v1 {
    
    use aptos_framework::coin::{Coin, Self};
    use std::signer::{address_of};
    use std::timestamp;

    /*
    Questo contratto rappresenta una scommessa tra due giocatori, la cui vittoria viene determinata da un oracolo.
    Le fasi della scommessa sono le seguenti:
    1) I giocatori partecipano alla scommessa mettendo in palio una somma di denaro,ad esempio 1 Coin, accordandosi su:
        - un oracolo che determina il vincitore
        - entro quanto tempo l'oracolo deve dare una risposta
    2) L'oracolo fornisce una risposta, che determina il vincitore tra uno dei due partecipanti e allo stesso momento invia la posta in palio al vincitore. Solo l'oracolo determina il vincitore.
    3) Se l'oracolo non fornisce una risposta entro il tempo stabilito, la posta in palio viene restituita ai giocatori. Questa operazione puo essere eseguita da chiunque.
    */

    struct OracleBet has key {
        player1: address,
        player2: address,
        oracle: address,
        stake: u64,
        deadline: u64,
    }

    struct Bet<phantom CoinType> has key {
        value: Coin<CoinType>
    }

    public fun initBet(bookmaker: &signer, player1: address, player2: address, oracle: address, stake: u64, deadline: u64) {
        let bet = OracleBet {
            player1,
            player2,
            oracle,
            stake,
            deadline
        };

        move_to(bookmaker, bet);
    }

    public fun join<CoinType>(better: &signer, bet: Coin<CoinType>, bookmaker: address) acquires OracleBet {
        // TODO: check if bet exists at bookmaker address if we do not want runtime error
        let oracleBet = borrow_global_mut<OracleBet>(bookmaker);
        // require better address is one of the two players
        assert!(address_of(better) == oracleBet.player1 || address_of(better) == oracleBet.player2, 0);
        // require bet value is equal to stake
        assert!(coin::value<CoinType>(&bet) == oracleBet.stake, 0);
        // TOUNDERSTAND: maybe we should set deadline here ??
        let bet = Bet { value: bet };

        move_to(better, bet);
    }

    public fun winner<CoinType>(oracle: &signer, winner: address, bookmaker: address) acquires OracleBet, Bet {
        assert!(exists<OracleBet>(bookmaker), 0);
        let OracleBet {
            player1,
            player2,
            oracle: oracle_address,
            stake: _,
            deadline: _
        } = move_from<OracleBet>(bookmaker);
        // TOUNDERSTAND: se questo assert fallisce, la transazione viene respinta senza side effect della move_from fatta sopra??
        assert!(address_of(oracle) == oracle_address, 0);
        assert!(winner == player1 || winner == player2, 0);
        let Bet { value: bet1 } = move_from<Bet<CoinType>>(player1);
        let Bet { value: bet2 } = move_from<Bet<CoinType>>(player2);
        coin::merge(&mut bet1,bet2);
        coin::deposit(winner, bet1 );
    }

    public fun timeout<CoinType>(bookmaker: address) acquires OracleBet, Bet {
        let OracleBet {
            player1,
            player2,
            oracle: _,
            stake: _,
            deadline
        } = move_from<OracleBet>(bookmaker);
        assert!(deadline < timestamp::now_seconds(), 0);
        // TOUNDERSTAND: theoretically, we should not check if winner function has been called, because it will raise runtime error if bet does not exist
        let Bet { value: bet1 } = move_from<Bet<CoinType>>(player1);
        let Bet { value: bet2 } = move_from<Bet<CoinType>>(player2);
        coin::deposit(player1, bet1);
        coin::deposit(player2, bet2);
    }

}