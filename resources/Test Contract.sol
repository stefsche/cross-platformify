@START ALL

@IF sol_V8   
pragma solidity ^0.8.0;
@END

@IF sol_V7 
pragma solidity ^0.7.0;
@END

contract Hello {
    string public message;

    @IF sol_V8   
    bytes1 = foo;
    function Inbox(string memory initialMessage) public {
        message = initialMessage;
    }
    @END

    string goo;

    @IF sol_V7
    byte = foo;
    function Inbox(string initialMessage) public {
        message = initialMessage;
    }
    @END
}