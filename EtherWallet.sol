// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract EtherWallet {
    address payable public owner;

    constructor() {
        owner = payable (msg.sender);
    }

    receive() external payable { }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not owner");
        _;
    }

    function withdraw(uint _amount) external onlyOwner {
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() external view returns (uint) {
        return address(this).balance; 
    }
}