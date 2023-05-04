# aptos-test
Testing Move language on Aptos Blockchain

## Example CLI commands 
Before running the commands, remember to **replace** ```deploy_address``` with your address in the ```Move.toml``` file.
Also make sure you have correctly **configured** aptos CLI to work in Devnet.

### Compile
```
aptos move compile
```

### Publish
```
aptos move publish --assume-yes
```

### Run move_fib entry function
This command runs the ```move_fib``` function inside ```fibonacci``` module.
Before running this commands, remember to **replace** the address with your deployer_address. Be careful to put 0x in front of it.
```
aptos move run --function-id 0x221e04878647f87928e83d1a0f0ec826a40364527027dca5a940d6ae95e8fdf1::fibonacci::move_fib --args u64:6 --assume-yes
```

### Run set_val entry function
This command runs the ```set_val``` function inside ```test``` module.
Before running this commands, remember to **replace** the address with your deployer_address. Be careful to put 0x in front of it.
```
aptos move run --function-id 0x221e04878647f87928e83d1a0f0ec826a40364527027dca5a940d6ae95e8fdf1::test::set_val --args u64:6 --assume-yes
```