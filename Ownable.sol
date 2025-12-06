// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Ownable  {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    function setOwner(address _owner) external onlyOwner{
        owner = _owner;
    }

    function pay() external onlyOwner {
        
    }


}