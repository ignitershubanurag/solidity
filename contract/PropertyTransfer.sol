// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.0;

contract PropertyTransfer {
    address public owner;
    uint256 public noOfProerty;
    constructor(uint8 _noProperty) {
        owner = msg.sender;
        noOfProerty = _noProperty;
    }

    struct Property {
        string name;
        bool isSold;
    }

    mapping (address => mapping(uint8 => Property)) public propertyOwner;
    mapping (address => uint8) public propertyOwnerCount;

    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
    }
}
