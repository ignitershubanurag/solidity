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
    mapping(address => uint)  public funders;
    uint public goalAmount;
    uint public timestamp;
    uint public minFundAmount;
    uint public totalFunders;
    address public owner;

    // to receive fund
    uint public requestAmount;
    address public AmountReceiver;
    uint public votes;
    address[] public funderVotes;
    
    constructor (uint _goal, uint _time) {
        owner = msg.sender;
        goalAmount = _goal;
        minFundAmount = 1000 wei;
        timestamp = block.timestamp + _time;
    }
    modifier checkOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier canFund(){
        require(timestamp > block.timestamp, "function duration exceeds");
        require(msg.sender != owner, "Owner can notfund");
        require(msg.value >= minFundAmount, "Min amount criteria not match");
        require(address(this).balance < goalAmount, "Goal reached");
        _;
    }

    function checkBalance() checkOwner public view returns(uint){
        return address(this).balance;
    }

    // length OR keys can not be fetched from mapping
    // function checkFunders() checkOwner public view returns(uint){
    //     return funders.length;
    // }

    receive() canFund external payable {
        if(funders[msg.sender]>0){
            funders[msg.sender] += msg.value;
        }else{
            funders[msg.sender] = msg.value;
            totalFunders++;
        }
    }

    function getRefund() public {
        require(timestamp < block.timestamp, "Funding round not over");
        // require(msg.sender != owner, "Owner can notfund");
        require(address(this).balance >= goalAmount, "Goal achieved");
        require(funders[msg.sender] > 0, "you are not funder");
        payable(msg.sender).transfer(funders[msg.sender]);
        funders[msg.sender] = 0;
        totalFunders--;
    }

    // for voting
    struct VotingRequests {
        string desc;
        uint amount;
        address payable receiver;
        uint noOfVoters;
        mapping(address => bool) votes;
        bool completed;
    }

    mapping (uint => VotingRequests) public allRequest;
    uint public numRequests;

    function createRequest(string memory _desc, uint _amount, address payable _receiver)
     public checkOwner {
         VotingRequests storage request = allRequest[numRequests];
         numRequests++;
         request.desc = _desc;
         request.amount = _amount;
         request.receiver = _receiver;
         request.completed = false;
         request.noOfVoters = 0;
         
    }

    function votingRequest(uint _requestNum) public{
        require(funders[msg.sender] > 0, "you are not funder");
        VotingRequests storage request = allRequest[_requestNum];
        require(request.votes[msg.sender] != true, "Already voted");
        request.votes[msg.sender] = true;
        request.noOfVoters++;
        
    }

}