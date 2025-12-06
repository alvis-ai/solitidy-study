// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;


contract Caller {
    function setX(address _test, uint _x) external {
        TestContract(_test).setX(_x);
    } 

    function getX(address _test) external view returns (uint) {
        return TestContract(_test).getX();
    }

     function setXAndSendEther(address _test, uint _x) external payable {
        TestContract(_test).setXAndSendEther{value:msg.value}(_x);
    } 

    function getXAndValue(address _test) external view returns (uint x, uint value) {
        (x, value) = TestContract(_test).getXAndValue();
    }
}


contract TestContract {
    uint256 public x;
    uint256 public value = 123;

    function setX(uint256 _x) public returns (uint256) {
        x = _x;
        return x;
    }

    function getX() external view returns (uint256) {
        return x;
    }

    function setXAndSendEther(uint256 _x) public payable returns (uint256, uint256) {
        x = _x;
        value = msg.value;
        return (x, value);
    }

    function getXAndValue() external view returns (uint, uint) {
        return (x, value);
    }
}