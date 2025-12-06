// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract IfElseDemo {
    function example(uint _x) external pure returns (uint) {
        if (_x > 9) {
            return 0;
        } else if (_x > 8) {
            return 2;
        }
        return 5;
    }

    function tenary(uint _y) external pure returns (uint) {
        return _y > 20 ? 1 : 2;
    }
}