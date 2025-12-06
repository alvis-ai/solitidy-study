// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract ErrorDemo {
    
    function testRequire(uint _i) external pure {
        require(_i <= 10, "i > 10");
    }

    
}