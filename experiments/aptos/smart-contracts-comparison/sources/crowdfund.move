/*
contract Crowdfund {

    uint end_donate;    // last block in which users can donate
    uint goal;          // amount of ETH that must be donated for the crowdfunding to be succesful
    address receiver;   // receiver of the donated funds
    mapping(address => uint) public donors;

    constructor (address payable receiver_, uint end_donate_, uint256 goal_) {
        receiver = receiver_;
        end_donate = end_donate_;
	goal = goal_;	
    }
    
    function donate() public payable {
        require (block.number <= end_donate);
        donors[msg.sender] += msg.value;
    }

    function withdraw() public {
        require (block.number >= end_donate);
        require (address(this).balance >= goal);
        (bool succ,) = receiver.call{value: address(this).balance}("");
        require(succ);
    }
    
    function reclaim() public { 
        require (block.number >= end_donate);
        require (address(this).balance < goal);
        require (donors[msg.sender] > 0);
        uint amount = donors[msg.sender];
        donors[msg.sender] = 0;
        (bool succ,) = msg.sender.call{value: amount}("");
        require(succ);
    }
}
*/
module deploy_address::crowdfund {
    use aptos_framework::coin::{Self, Coin};
    use aptos_framework::signer;

    struct Crowdfund<phantom CoinType> has key {
        end_donate: u64,    // last block in which users can donate
        goal: u64,          // amount of CoinType that must be donated for the crowdfunding to be succesful
        receiver: address,   // receiver of the donated funds
        funding: Coin<CoinType>,
    }

    struct Receipt<phantom CoinType> has key {
        amount: u64,
    }

    public fun init<CoinType>(crowdFundingOwner: &signer, end_donate: u64, goal: u64, receiver: address) {
        let funding = coin::zero<CoinType>();
        let crowdfund = Crowdfund {
            end_donate,
            goal,
            receiver,
            funding,
        };
        move_to(crowdFundingOwner, crowdfund);

    }

    public fun donate<CoinType>(sender: &signer, crowdFundingOwner: address, donation: Coin<CoinType>) acquires Crowdfund {
        let crowdfund = borrow_global_mut<Crowdfund<CoinType>>(crowdFundingOwner);
        // assert(block_number() <= crowdfund.end_donate);
        let receipt = Receipt<CoinType> {
            amount: coin::value(&donation),
        };
        coin::merge(&mut crowdfund.funding, donation);
        move_to(sender, receipt);

    }

    public fun withdraw<CoinType>(sender: &signer, crowdFundingOwner: address) acquires Crowdfund, Receipt {
        let crowdfund = borrow_global_mut<Crowdfund<CoinType>>(crowdFundingOwner);
        // TODO some asserts
        let Receipt { amount } = move_from<Receipt<CoinType>>(signer::address_of(sender));
        let donation = coin::extract(&mut crowdfund.funding, amount);
        coin::deposit(signer::address_of(sender), donation);
    }
}