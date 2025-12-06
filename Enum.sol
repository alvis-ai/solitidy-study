// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract Enum {
    enum Status {
        None,
        Pending,
        Shipped,
        Completed,
        Rejected,
        Canceled
    }

    struct Order {
        address buyer;
        Status status; 
    }

    Status public status;

    Order[] public orders;


    function getStatus() public view returns (Status) {
        return status;
    }

    function setStatus(Status _status) external {
        status = _status;
    }

    function ship() external {
        status = Status.Shipped;
    }
    
    function reset() external {
        delete status;
    }
}