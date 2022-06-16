// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.11;
/*
User can transfer fund to contract
there should be min amount for funding

There should be limit for amount and time with goal
if fund not collected within time then all fund should be returned

can start voting for funders to spend money, min should be greater than 50%

*/
contract CrowdFunding {

    // need to check how mapping of address can be payable type
    mapping(address => uint)  funders;
    uint public goalAmount;
    uint public minFundAmount;
    address public owner;
    constructor () {
        owner = msg.sender;
        goalAmount = 10 ether;
        minFundAmount = 1 ether;
    }
    modifier checkOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier canFund(){
        require(msg.sender != owner, "Owner can notfund");
        require(msg.value >= minFundAmount, "Min amount criteria not match");
        require(address(this).balance < goalAmount, "Goal reached");
        _;
    }

    function checkBalance() checkOwner public view returns(uint){
        return address(this).balance;
    }

    receive() canFund external payable {
        funders[msg.sender] = msg.value;
    }

}