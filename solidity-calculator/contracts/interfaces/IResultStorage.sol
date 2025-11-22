// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IResultStorage {
    function getResult() external view returns (uint);

    function setResult(uint _newResult) external;
}
