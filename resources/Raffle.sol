@START ALL
//SPDX-License-Identifier: UNLICENSED
@@ v4.21 pragma solidity >=0.4.0 <0.4.22;
@@ v4.22 pragma solidity >=0.4.22 ^0.4.0;
@@ v5 pragma solidity ^0.5.0;
@@ v6 pragma solidity ^0.6.0;
@@ v7 pragma solidity ^0.7.0;
@@ Tron_v7 pragma solidity ^0.7.0;
contract Raffle{
    uint contractTime;
    address contractAddress;
    mapping(address => bool) public participated;
    mapping(address => string) public names;
    address[] participants;
    @IF v4.21
    function Raffle() public{
        contractTime = now;
        contractAddress = address(this);
    }
    @END
    @IF v4.22, v5, v6
    constructor() public {
        contractTime = now;
        contractAddress = address(this);
    }
    @END
    @IF v7, Tron_v7
    constructor() {
        contractTime = block.timestamp;
        contractAddress = address(this);
    }
    @END
    @IF v4.21
    function payWinner() public payable returns(string){
        require(address(this).balance > 0);
        require(participated[msg.sender] == true);
        require(calcTimeElapsed() == true);
        address winnerAddress = participants[getRandParticipant()];
        winnerAddress.transfer(address(this).balance);
        string winnerName = names[winnerAddress];
        contractTime = now;
        for(uint i=0; i < participants.length; i++){
            participated[participants[i]] = false;
        }
        return winnerName;
    }
    @END
    @IF v4.22
    function payWinner() public payable returns(string){
        require(address(this).balance > 0);
        require(participated[msg.sender] == true);
        require(calcTimeElapsed() == true);
        address winnerAddress = participants[getRandParticipant()];
        winnerAddress.transfer(address(this).balance);
        string winnerName = names[winnerAddress];
        contractTime = now;
        for(uint i=0; i < participants.length; i++){
            participated[participants[i]] = false;
        }
        return string(abi.encodePacked("Winner is: " , winnerName));
    }
    @END
    @IF v5, v6, v7, Tron_v7
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
    @END
    @IF v6, v7
    function enterRaffle(uint256 amount, string memory name) public payable{
        require(amount > 0 && bytes(name).length > 0, "Invalid parameters");
        require(msg.value == 1 ether, "You must pay 1 ether");
        require(participated[msg.sender] == false, "This address has already participated");
        participated[msg.sender] = true;
        names[msg.sender] = name;
        participants.push(msg.sender);
    }
    @END
    @IF Tron_v7
    function enterRaffle(uint256 amount, string memory name) public payable{
        require(amount > 0 && bytes(name).length > 0, "Invalid parameters");
        require(msg.value == 1 trx, "You must pay 1 trx");
        require(participated[msg.sender] == false, "This address has already participated");
        participated[msg.sender] = true;
        names[msg.sender] = name;
        participants.push(msg.sender);
    }
    @END
    @IF v5
    function enterRaffle(uint256 amount, string memory name) public payable{
        require(amount > 0 && bytes(name).length > 0);
        require(msg.value == 1 ether);
        require(participated[msg.sender] == false);
        participated[msg.sender] = true;
        names[msg.sender] = name;
        participants.push(msg.sender);
    }
    @END
    @IF v4.21, v4.22
    function enterRaffle(uint256 amount, string name) public payable{
        require(amount > 0 && bytes(name).length > 0);
        require(msg.value == 1 ether);
        require(participated[msg.sender] == false);
        participated[msg.sender] = true;
        names[msg.sender] = name;
        participants.push(msg.sender);
    }
    @END
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    function getContractTime() public view returns(uint){
        return contractTime;
    }
    function getRandParticipant() private view returns(uint){
        return random() % participants.length;
    }
    @IF v4.21
    function random() private view returns(uint){
        return uint(keccak256(block.difficulty, now, participants));
    }
    @END
    @IF v4.22, v5, v6, v7, Tron_v7
    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants)));
    }
    @END
    @IF v6, v5, v4.22, v4.21
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
    @END
    @IF v7, Tron_v7
    function calcTimeElapsed() private view returns(bool){
        uint time = block.timestamp - contractTime;
        if(time >= 1 minutes){
            return true;
        }
        else{
            return false;
        }
    }
    function calcTimeDifference() public view returns(uint){
        return block.timestamp - contractTime;
    }
    function getUserTime() public view returns(uint){
        return block.timestamp;
    }
    @END
}