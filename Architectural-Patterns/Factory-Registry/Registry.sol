pragma solidity 0.4.24;

contract Registry {
    
    struct ContractDetails {
        address owner;
        address contractAddress;
    }
    
    mapping (string => ContractDetails) nameToContract;
    string[] contractNames;
    
    modifier validAddress(address _adr) {
        require(_adr != address(0));
        _;
    }
    
    modifier validInput(string _str) {
        require(keccak256(_str) != keccak256(""));
        _;
    }
    
    function registerContract(string _name, address _owner, address _contractAddress) internal
        validInput(_name) validAddress(_owner) validAddress(_contractAddress) {
            
        ContractDetails memory contractDetails = ContractDetails(_owner, _contractAddress);
        nameToContract[_name] = contractDetails;
        contractNames.push(_name);
    }
    
    function getContractFromRegistry(string _name) public view returns (address, address) {
        ContractDetails memory contractDetails = nameToContract[_name];
        return (
                contractDetails.owner,
                contractDetails.contractAddress
            );
    }
    
}