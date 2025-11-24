// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IMoveLibrary.sol";

// 난수 생성 및 전진 결정 로직을 담당하는 유틸 라이브러리
contract RandomMoveLogic is IMoveLibrary {
    uint256 internal constant FORWARD_THRESHOLD = 4;
    uint256 internal constant MAX_RANDOM_VALUE = 9;

    function shouldMove() external override returns (bool) {
        uint256 randomValue = _generatePseudoRandom();
        return randomValue >= FORWARD_THRESHOLD;
    }

    // 현재 블록 정보를 기반으로 유사 난수 생성
    // 주의: EVM에서 생성된 난수는 예측 가능함 -> 보안 취약
    function _generatePseudoRandom() internal view returns (uint256) {
        uint256 seed = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.prevrandao, msg.sender)
            )
        );
        return seed % (MAX_RANDOM_VALUE + 1);
    }
}
