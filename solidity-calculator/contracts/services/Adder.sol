// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IAdder.sol";

contract Adder is IAdder {
    function add(
        uint256[] calldata numbers
    ) external pure override returns (uint) {
        uint256 sum = 0;

        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        return sum;
    }
}
