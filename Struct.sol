// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract StructDemo {
    
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping(address=> Car[]) carsByOwner;

    function exmaples() external {
        Car memory toyota = Car("Toyota", 1990, msg.sender);
        Car memory lambo = Car({year:1999, model:"Lambo", owner:address(2)});
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2000;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        
    }
}