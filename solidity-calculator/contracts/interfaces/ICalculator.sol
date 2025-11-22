// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICalculator {
    function calculate(string memory input) external view returns (uint256);
}
