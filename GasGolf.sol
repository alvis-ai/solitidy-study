// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;


// start 49730 gas
// calldata  32630 gas
// 47790



contract GasGolf {
    uint256 public total;

    // [1,2,3,4,5,100]
    function sumIfEvenAndLessThan99(uint[] calldata nums) external {
        uint _total = total;
        for (uint i; i < nums.length; i++) {
            bool isEven = nums[i] % 2 == 0;
            bool lessThan99 = nums[i] < 99;
            if (isEven && lessThan99) {
                _total += nums[i];
            }
        }
        total = _total;
    }
}