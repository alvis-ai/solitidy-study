// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract ValueTypes {
    bool public b = true;
    uint public u = 123;

    int public i = -123;
    int public mMin = type(int).min;
    int public mMax = type(int).max;

    address public addr = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    bytes32 public b32 = 0xd9145CCE52D386f254917e481eB44e9943F39138DFADFADADFDFADFADADFFFFF;
}