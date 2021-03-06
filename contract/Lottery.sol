// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.11;
contract Lottery {
    string private name;
    address public owner;
    address payable[] public participant;
    constructor(string memory _name){
        name = _name;
        owner = msg.sender;
    }
    modifier checkOwner(){
        require(owner == msg.sender, "Only owner can access");
        _;
    }
    modifier canParticipate(){
        require(owner != msg.sender, "Owner can not participate");
        _;
    }
    receive() external payable canParticipate{
        require(msg.value==1 ether);
        participant.push(payable(msg.sender));
    }

    function display() view public checkOwner returns(string memory, address){
        return (name, owner);
    }

    function getParticipate() public checkOwner view returns(address payable[] memory){
        return participant;
    }

    function balance() public checkOwner view returns(uint){
        return address(this).balance;
    }
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participant.length)));
    }

    function selectWinner() public checkOwner {
        require(participant.length > 3);
        uint num = random()%participant.length;
        address payable winner = participant[num];
        winner.transfer(balance());
        participant = new address payable[](0);
    }
}