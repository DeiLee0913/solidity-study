// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IMoveLibrary.sol";

// 블록 번호에 따라 전진 여부를 결정하는 결정론적 로직 계약
contract BlockNumberMoveLogic is IMoveLibrary {
    function shouldMove() external view override returns (bool) {
        // 블록 번호가 짝수일 때만 true(전진) 반환
        // 난수 예측 가능성 문제 없이 항상 동일한 결과 보장
        return block.number % 2 == 0;
    }
}
