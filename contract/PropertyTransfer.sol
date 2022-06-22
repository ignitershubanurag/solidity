// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.0;

contract PropertyTransfer {
    address public owner;
    uint256 public totalNoOfProerty;
    constructor(uint8 _noProperty) {
        owner = msg.sender;
        totalNoOfProerty = _noProperty;
    }

    struct Property {
        string name;
        bool isSold;
    }

    mapping (address => mapping(uint256 => Property)) public propertyOwner;
    mapping (address => uint256) public propertyOwnerCount;

    modifier onlyOwner(){
        require(owner == msg.sender);
        _;
    }

    event PropertyAlloted(address indexed _propertyOwner, uint256 indexed _propertyCount, string _propertyName, string _msg);
    event PropertyTansferred(address indexed _from, address indexed _to, string _propertyName, string _msg);

// check constant in place of public
    function PropertyCount(address _owner) public view returns(uint256){
        uint count = 0;
        for(uint i=0; i<propertyOwnerCount[_owner]; i++){
            if(propertyOwner[_owner][i].isSold != true){
                count++;
            }
        }
        return count;
    }

    function PropertyAllot(address _owner, string calldata _propertyName) onlyOwner public {
        Property memory property;
        property.name = _propertyName;
        property.isSold = false;
        uint256 propertyCount = propertyOwnerCount[_owner];
        propertyOwner[_owner][propertyCount] = property;
        propertyOwnerCount[_owner] = propertyOwnerCount[_owner]+1;
        totalNoOfProerty++;
        emit PropertyAlloted(_owner, propertyOwnerCount[_owner], _propertyName, "Property Allot by owner");
    }

    function isPropertyOwner(address _owner, string calldata _propertyName) public view returns(uint){
        for(uint i=0; i<propertyOwnerCount[_owner]; i++){
            if(keccak256(bytes(propertyOwner[_owner][i].name)) == keccak256(bytes(_propertyName)) && propertyOwner[_owner][i].isSold != true){
                return i;
            }
        }
        return 9999999999; // assuming no property
    }
    function stringsEquall(string calldata _str1, string calldata _str2) internal pure returns(bool){
        return keccak256(bytes(_str1)) == keccak256(bytes(_str2)) ? true : false;
    }

    function TransferProperty(address _receiver, string calldata _propertyName) public returns(bool, uint) {
        uint256 propCount = isPropertyOwner(msg.sender, _propertyName);
        if(propCount != 9999999999 && propertyOwner[msg.sender][propCount].isSold != true){
            Property memory property = propertyOwner[msg.sender][propCount];
            
            propertyOwner[msg.sender][propCount].isSold = true;
            
            uint256 propertyCount = propertyOwnerCount[_receiver];
            propertyOwner[_receiver][propertyCount] = property;
            propertyOwnerCount[_receiver] = propertyOwnerCount[_receiver]+1;
            
            emit PropertyTansferred(msg.sender, _receiver, _propertyName, "Property Transferred");

            return(true, propCount);
        }else{
            return(false, 0);
        }
    }
}
