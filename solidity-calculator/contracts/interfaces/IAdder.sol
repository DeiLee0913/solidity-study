// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAdder {
    function add(uint256[] calldata numbers) external pure returns (uint256);
}
