# Cross-Platformify
A Python and TextX based tool for handling cross-platform code.

This project is aimed at easing the burden of code maintenance that developers face when developing a solution consisting of multiple platforms. It is a way developers can seamlessly maintain cross-platform code using annotations to specify which platform the code blocks belong to.

The main motivation for this tool was the lack of cross-platform code maintenance tools available in the Smart Contract development area. Such tools are a great benefit in a platform-rich area. Smart contract devs need to keep up with frequent language (such as Solidity) changes and also have to handle slightly different code for multiple blockchain platforms spread across multiple files.

Using cross-platformify, devs can merge code for different platforms into however many files they see fit and feed it to the tool to get the compile-ready files, making it easier to focus on the high-level logic of the solution.

## Pre-requisites

Python 3 or newer


## Installation and Usage

 1. Clone this repository or download as zip. (Important to keep the same directory structure!)
 2. Open a terminal window and navigate to the **src** folder
 3. Run **main** file and enter the path to the file which should be processed
Example: `python main.py "C:\Users\Documents\GitHub\cross-platformify\resources\Raffle.sol"`
 4. The generated files can be found in the same directory as the source file

## Grammar
The Grammar language used for cross-platformify is TextX.

Note:
 - All **annotations** start with the '**@**' identifier and **single-line** annotations start with '**@@**'
 - Keywords and identifiers are **case-sensitive**


At the very **beginning** of the source file, the start indicator should be included. Here, if the keyword "ALL" is included, then files for all the annotations found within the source file will be generated. Alternatively, you can specify which annotations you would like the code for individually.
Example: 
`@START ALL`
or 
`@START eth_v7, eth_v8, tron_v8`

Single-line unique code must start with '**@@**'. Immediately after, a white-space followed by the **identifier** must be included. The identifier takes a **single token** and **terminates at the first white-space**.
Example:

    @@ eth_v7 pragma  solidity ^0.7.0;
    @@ eth_v8 pragma  solidity ^0.8.0;
Unique code-blocks are identified between the **@IF <identifier_list>** and the **@END** keywords.
Example:

    @IF eth_v7, eth_v8
    function  enterRaffle(uint256  amount, string  memory  name) public  payable{
	    require(amount > 0 && bytes(name).length > 0, "Invalid parameters");
	    require(msg.value == 1  ether, "You must pay 1 ether");
	    require(participated[msg.sender] == false, "This address has already participated");
	    participated[msg.sender] = true;
	    names[msg.sender] = name;
	    participants.push(msg.sender);
    }
    @END
    @IF tron_v7
    function  enterRaffle(uint256  amount, string  memory  name) public  payable{
	    require(amount > 0 && bytes(name).length > 0, "Invalid parameters");
	    require(msg.value == 1 trx, "You must pay 1 trx");
	    require(participated[msg.sender] == false, "This address has already participated");
	    participated[msg.sender] = true;
	    names[msg.sender] = name;
	    participants.push(msg.sender);
    }
    @END
All other code is considered common code and will be included in every file generated.
