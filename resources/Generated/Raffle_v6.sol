//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
contract Raffle{
    uint contractTime;
    address contractAddress;
    mapping(address => bool) public participated;
    mapping(address => string) public names;
    address[] participants;
    constructor() public {
        contractTime = now;
        contractAddress = address(this);
    }
    function payWinner() public payable returns(string memory){
        require(address(this).balance > 0, "Not enough Ether available.");
        require(participated[msg.sender] == true, "This address has not participated");
        require(calcTimeElapsed() == true, "Not enough time elapsed. Try again later.");
        address winnerAddress = participants[getRandParticipant()];
        payable(winnerAddress).transfer(address(this).balance);
        string memory winnerName = names[winnerAddress];
        contractTime = block.timestamp;
        for(uint i=0; i < participants.length; i++){
            participated[participants[i]] = false;
        }
        return string(abi.encodePacked("Winner is: " , winnerName));
    }
    function enterRaffle(uint256 amount, string memory name) public payable{
        require(amount > 0 && bytes(name).length > 0, "Invalid parameters");
        require(msg.value == 1 ether, "You must pay 1 ether");
        require(participated[msg.sender] == false, "This address has already participated");
        participated[msg.sender] = true;
        names[msg.sender] = name;
        participants.push(msg.sender);
    }
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
        function getContractTime() public view returns(uint){
        return contractTime;
    }
    function getRandParticipant() private view returns(uint){
        return random() % participants.length;
    }
    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants)));
    }
    function calcTimeElapsed() private view returns(bool){
        uint time = now - contractTime;
        if(time >= 1 minutes){
            return true;
        }
        else{
            return false;
        }
    }
    function calcTimeDifference() public view returns(uint){
        return now - contractTime;
    }
    function getUserTime() public view returns(uint){
        return now;
    }
}
