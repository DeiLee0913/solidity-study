// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 난수 생성 및 전진 결정 로직을 담당하는 유틸 라이브러리
library RandomMoveLibrary {
    uint256 internal constant FORWARD_THRESHOLD = 4;
    uint256 internal constant MAX_RANDOM_VALUE = 9;

    // 현재 블록 정보를 기반으로 유사 난수 생성
    // 주의: EVM에서 생성된 난수는 예측 가능함 -> 보안 취약
    function generatePseudoRandom() internal view returns (uint256) {
        // block.timestamp와 block.difficulty를 조합하여 해시 생성
        uint256 seed = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.prevrandao, msg.sender)
            )
        );

        // 시드 값을 10으로 나눈 나머지를 얻어 0~9 사이의 랜덤 수를 얻어냄
        return seed % (MAX_RANDOM_VALUE + 1);
    }

    function shouldMove(uint256 _randomValue) internal pure returns (bool) {
        return _randomValue >= FORWARD_THRESHOLD;
    }
}
