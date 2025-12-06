// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract FunctionOutput {
    

    function returnMany() public  pure returns (uint , bool) {
        return (1, true);
    }

    function namedReturn() public pure returns (uint x, bool b) {
        return (2, false);
    }

    function assignReturn() public pure returns (uint x, bool b) {
        x = 4;
        b = true;
    }

    function distructingAssignment() public pure {
        //(uint x, bool b) = returnMany();
    }
}