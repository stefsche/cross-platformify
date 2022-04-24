//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.0 <0.4.22;
contract Raffle{
    uint contractTime;
    address contractAddress;
    mapping(address => bool) public participated;
    mapping(address => string) public names;
    address[] participants;
    function V4() public{
        contractTime = now;
        contractAddress = address(this);
    }
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
    function enterRaffle(uint256 amount, string name) public payable{
        require(amount > 0 && bytes(name).length > 0);
        require(msg.value == 1 ether);
        require(participated[msg.sender] == false);
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
        return uint(keccak256(block.difficulty, now, participants));
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
