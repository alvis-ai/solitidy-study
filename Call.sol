// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract TextCall {
    string public message;
    uint public x;

    event Log(address caller, uint256 amount, string message);

    receive() external payable { }

    fallback() external payable {
        emit Log(msg.sender, msg.value, "fallback called");
    }

    function foo(string memory _message, uint256 _x) public payable returns (bool, uint) {
        message = _message;
        x = _x;
        return (true,99);
    }
    
}

contract Caller {
    bytes public data;
    function callFoo(address _test) external payable  {
       (bool success, bytes memory _data) =  _test.call{value: 121}(abi.encodeWithSignature("foo(string,uint256)", "call foo", 123));
       require(success, "call failed");
       data = _data;
    }

    function callNotExist(address _test) external {
        (bool success,) = _test.call(abi.encodeWithSignature("deee"));
        require(success, "call not exist");
    }
}