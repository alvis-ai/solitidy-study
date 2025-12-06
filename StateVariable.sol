// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract StateVariables {
    uint public myUint;
    bool public myBool;
    address public myAddr;


    function foo() external {
        //uint a = 1;
        //bool b = true;
        //address localAddr = address(1);

        myUint = 123;
        myBool = true;
        myAddr = address(2);
    }
}