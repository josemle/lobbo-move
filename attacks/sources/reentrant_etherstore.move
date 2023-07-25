module deploy_address::reentrant_etherstore
 {

	/*contract EtherStore {
		mapping(address => uint) public balances;

		function deposit() public payable {
			balances[msg.sender] += msg.value;
		}

		function withdraw() public {
			uint bal = balances[msg.sender];
			require(bal > 0);

			(bool sent, ) = msg.sender.call{value: bal}("");
			require(sent, "Failed to send Ether");

			balances[msg.sender] = 0;
		}

		// Helper function to check the balance of this contract
		function getBalance() public view returns (uint) {
			return address(this).balance;
		}
	}*/

	use deploy_address::reentrant_attacker;

	struct Balance has key {
		amount: u64
	}

	public fun deposit(acc: &signer, amount: u64) {
		move_to(acc, Balance { amount });
	}

	public fun withdraw(addr: address) acquires Balance {
		let bal = borrow_global_mut<Balance>(addr);
		assert!(bal.amount > 0, 1);

		reentrant_attacker::fallback(addr);

		bal.amount = 0;
	}




}
