## blockchain-tools

**`blockchain-tools` is a Solidity library for bitcoin-related functionality written in Solidity.**

It implements encoding/decoding bitcoin addresses. 
Implementation is slightly optimized for Solidity (e.g. it uses the fact that uint256 is 256 bits).
Currently, it supports:
1. Segwit v0 address BIP-0173
2. Segwit v1 address (taproot) BIP-0350 
3. Encoding/decoding returns specific error thus making debugging much easier
4. Almost all tests from [Python reference implementation](https://github.com/sipa/bech32/tree/master/ref/python) are implemented

Solidity code for tests was generated automatically using scripts from `python_ref` dir. This scripts use test data and functions from [Python reference implementation](https://github.com/sipa/bech32/tree/master/ref/python) for BIP-0350.

It uses an excellent tool [Foundry](https://book.getfoundry.sh/).

## Usage

### Install the library
```shell
$ forge install --no-commit https://github.com/stroomnetwork/blockchain-tools
```

### Add remappings
Add the following line to file `remappings.txt`. If the file does not exist, create it.
```
blockchain-tools/=lib/blockchain-tools/src
```

### Import encoding/decoding library
```solidity
import {Bech32m} from "blockchain-tools/Bech32m.sol";
```

### To decode Bitcoin address
```solidity
(uint8 witVer, bytes memory data, Bech32m.DecodeError err) = Bech32m.decodeSegwitAddress(bytes("tb"), bytes("tb1p5z8wl5tu7m0d79vzqqsl9gu0x4fkjug857fusx4fl4kfgwh5j25spa7245"));
```

### To encode Bitcoin address
```solidity
bytes memory btcAddr = Bech32m.encodeSegwitAddress(bytes("tb"), 1, hex"a08eefd17cf6dedf15820021f2a38f3553697107a793c81aa9fd6c943af492a9");
```

## Sample Contract
It includes one sample contract which calculates bitcoin address given an ethereum address `BTCDepositAddressDeriver`. pk = pk1 * hash(pk1 || bytes(eth_address)) + pk2 * hash(pk2 || bytes(eth_address)). pk1 and pk2 are public keys corresponding to two Taproot addresses. 
It deterministically generate individual bitcoin address for an eth address. It can be used to bridge Bitcoin and Ethereum.

By default `anvil` uses deterministic address generation from seed. So each launch of anvil will give the same addresses and private keys. For usability they are copy-pasted in `env-anvil` file.

Commands for deploying and interacting are slightly large, so they were put in `Makefile`. Most commands have form `make <action>-<object>`.

### Get Help
```shell 
$ make
```
OR
```shell
$ make help
```

Prints help message with a list of available commands and some descriptions.

### Build
```shell 
$ make build
```
builds the library.

### Clean
```shell 
$ make clean
```
Cleans output cache. Sometimes when renaming files and/or changing submodules very strange errors appear. Most probably due to `forge` caching. This command deletes project related cache file. Basically it deletes `cache` and `out` directories. 

NOTE: it is different from `$ forge clean`. I don't know why `$ forge clean` still leaves some files and thus it is not "complete" clean. Thus `$ make clean` was created.

### Start anvil
```shell
$ make start-anvil
``` 
starts `anvil` with the default settings.

### Deploy sample contract `BTCDepositAddressDeriver`
```shell 
$ make deploy-on-anvil
``` 
deploys `BTCDepositAddressDeriver` on the local anvil blockchain. It writes the deployed contract address to `temp/BTCDepositAddressDeriver.31337.address`.

### Set seed in deployed contract
```shell 
$ make set-sample-seed
``` 
Set seed for previously deployed `BTCDepositAddressDeriver`. Btc seed addresses are hardcoded so the operation is deterministic.
TODO: explain what contract address it uses.

### Calculate bitcoin address from a given ethereum address
```shell 
$ make get-sample-btc-address
```
Generate bitcoin address from an eth address. Eth address is hard-coded so this operation is deterministic.

### Run unit tests
```shell 
$ make test
``` 
Run unit-tests.

### Run integration tests
```shell 
$ make test-sample-flow
```
Run integration test. Deploy contract, set seed, generate btc address. Check that the address is correct.

Note: this command requires already running `anvil`. 

### Run all tests
```shell 
$ make test-all
```
Run both unit and integration tests.

Note: this command requires already running `anvil`. 

## Using `cast`
Cast is a command line tool for interacting with smart contracts. It is a part of Foundry.

Private keys and RPC URL for default `anvil` configuration are stored in `env-anvil`. `anvil` uses deterministic key generation and thus keys are the same for different launches.
To import these values.
```shell
$ source env-anvil
```

To get value of `btcAddr1` field.
```shell
$ cast call $(cat temp/BTCDepositAddressDeriver.31337.address) "btcAddr1()" --rpc-url $ANVIL_RPC_URL
```
It returns value of `btcAddr` field in hex. 

To get the value of `btcAddr` as string:
```shell
$ cast --to-utf8 $(cast call $(cat temp/BTCDepositAddressDeriver.31337.address) "btcAddr1()" --rpc-url $ANVIL_RPC_URL)
``` 

TODO: cast set-seed

TODO: cast get eth address

TODO: gas usage

