pragma solidity ^0.5.1;

import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Random is usingOraclize { 
    uint public randomNumber;
    
    constructor() payable public {
        // set proof
        oraclize_setProof(proofType_Android | proofStorage_IPFS);
    }
    
    // callback function after the oraclize query
    function __callback(bytes32 queryId, string memory result, bytes memory proof) public {
        require(msg.sender == oraclize_cbAddress());
        randomNumber = parseInt(result);
    }
    
    function getRandomNumber() public payable {
        // IPFS HASH CONTAINING PYTHON SCRIPT THAT GETS RANDOM NUMBER
        oraclize_query("computation", ["QmTRm7ubPAruzwp6Cw2bqqZzgRtWgxoi7mPddF31LB3u7w"]);
    }
}