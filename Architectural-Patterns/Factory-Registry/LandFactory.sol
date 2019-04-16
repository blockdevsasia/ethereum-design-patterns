pragma solidity 0.4.24;

import './Registry.sol';

// LAND ASSET CONTRACT
contract Land {
    
    string public location;
    uint[] public coordinates;
    uint public area;
    address public owner;
    
    constructor(string _location, uint[] _coordinates, uint _area, address _owner) {
        location = _location;
        coordinates = _coordinates;
        area = _area;
        owner = _owner;
    }
}

contract LandFactory is Registry {
    
    address owner;
    mapping (address => address) ownerToLandAddress;
    address[] landAddresses;
    
    constructor() public payable {
        owner = msg.sender;
        landAddresses = new address[](0);
    }
    
    // needs to convert coordinates to floating numbers
    function addLand(string _name, string _location, uint[] _coordinates, uint _area, address _owner) public {
        // bytes32[] memory convertedCoordinates = new bytes32[](0);
        // for (uint i = 0; i < _coordinates.length; i++) {
        //     convertedCoordinates[i] = keccak256(_coordinates[i]);
        // }
        Land newLand = new Land(_location, _coordinates, _area, _owner);
        landAddresses.push(newLand);
        ownerToLandAddress[_owner] = newLand;
        
        registerContract(_name, _owner, newLand);
    }
    
    function getLandByOwner(address _owner) public view returns (address) {
        return ownerToLandAddress[_owner];
    }
}