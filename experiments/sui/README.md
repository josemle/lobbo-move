# Sui test
Testing Move language on Sui Blockchain

## Example CLI commands 
Make sure you have correctly **configured** sui CLI.

### Compile
In order to compile you need a Move.toml configuration file.
```
sui move build
```
This produces the ```build``` folder with the compiled code in it.

### Disassemble
```
sui move disassemble [path-to-the-file]
```