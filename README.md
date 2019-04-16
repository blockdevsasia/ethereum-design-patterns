# Ethereum Design Patterns


### Security Patterns

  - **Access Restriction** - restricts access to a function (e.g: access permissions)
  - **Check Effect Interactions** - reduces risks of re-entrancy attacks after external calls of a function
  - **Guard Check** - validates the function behaviour to unexpected inputs
  - **Pull Over Push** - shift the risk associated with transferring ether to addresses
  - **Emergency Stop** - disable contract functionalities in case of emergency

### Behavioral Patterns

  - **State Machine** - set stages where the contract functionality behaves differently
  - **Commit Reveal** - have confidentiality of data within a period of time (e.g: voting)
  - **Randomness** - generate a psuedo random number within the blockchain
  - **Oracles** - use of external data outside of blockchain from trusted sources (e.g: weather forecast)
  - **Contract Self Destruction** - remove the contract permanently from the blockchain

### Architectural Patterns

  - **Contract Factory** - a parent contract can create its children contracts
  - **Name Registry** - keep track of all other dependency contracts within a single contract
  - **Proxy Delegation** - upgrade the logic of a smart contract without redeploying the original contract
  - **Eternal Storage** - keep track all the data of a contract after upgrades used with proxy delegation pattern

### Usage

Example implementation are developed with 0.4.24 solidity version.
Clone the contracts from this repo and try them out in remix.

```sh
$ cd dillinger
$ npm install -d
$ node app
```

### File Structure

| Pattern | Remarks |
| ------ | ------ |
| Security Pattern | Inside [Security-Patterns] Branch. Read Instructions |
| Commit-Reveal | Inside [Behavioral-Patterns] Branch. Read Instructions |
| Random-Oraclize | Inside [Behavioral-Patterns] Branch. Read Instructions |
| State-Machine | Inside [Behavioral-Patterns] Branch. Read Instructions |
| Factory-Registry | Inside [Architectural-Patterns] Branch. Read Instructions |
| Proxy Delegation-Eternal Storage | Inside [Architectural-Patterns] Branch. Read Instructions |


### Sources

 - Consensys Ethereum Developer Training
 - Blockchain Institute of UnionBank

