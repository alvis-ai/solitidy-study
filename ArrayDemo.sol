// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract ArrayDemo {
    uint[] public nums = [1,2,3];
    uint[3] public numsFixed = [4,5,6];

    function examples() external  {
        nums.push(4);
        //uint x = nums[1];
        nums[2] = 666;
        delete nums[1];
        nums.pop();
        //uint len = nums.length;

        //uint[] memory a = new uint[](5);
    }
}