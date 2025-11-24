// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IResultStorage.sol";

// 데이터 저장소(모델 역할)
contract ResultStorage is IResultStorage {
    uint public result;

    function getResult() public view returns (uint) {
        return result;
    }

    // only accessible by authroized logic contracts
    function setResult(uint _newResult) public {
        // TODO: Access Control 로직 추가
        result = _newResult;
    }
}
