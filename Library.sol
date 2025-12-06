// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

library Math {
    function max(uint _x, uint _y) internal pure returns (uint) {
        return _x >= _y ? _x : _y;
    }
}

contract TextMax {
    function findMax(uint _x, uint _y) external pure returns (uint) {
        return Math.max(_x, _y);
    }
}