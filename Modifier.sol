// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract FunctionModifier {
    
    uint public  count = 0;
    bool public pause = false;

    function setPause(bool _pause) external {
        pause = _pause;
    }

    modifier whenNotPaused() {
        require(!pause, "paused");
        _;
    }

    function inc() external whenNotPaused {
        count +=  1;
    }

    function dec() external whenNotPaused {
        count -=  1;
    }

    modifier cap(uint _x){
        require(_x < 100, "x >= 100");
        _;
    }

    function incBy(uint _x) external whenNotPaused cap(_x) {
        count += _x;
    }



}