// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;
//372 gas
contract Constants {
    address public constant MY_ADDRESS = 0x0000000000000000000000000000000000000000;
    uint public constant MY_UINT = 98;

}
//2507 gas
contract Vars {
    address public myAdrrs = 0x0000000000000000000000000000000000000000;
    uint public myUint = 98;

}