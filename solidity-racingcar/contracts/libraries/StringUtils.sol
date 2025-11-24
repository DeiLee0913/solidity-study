// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/CarStruct.sol";

library StringUtils {
    // 독립적인 static 함수로 정의, RacingGame.sol 또는 Race.sol에서 필요한 인자를 전달받아 사용
    // 우승자 목록을 포맷팅하여 문자열로 반환
    function buildWinnerText(
        CarStruct.Car[] storage _cars,
        uint256 _maxPos
    ) internal view returns (string memory) {
        string memory result = "";
        bool isFirst = true;

        for (uint256 i = 0; i < _cars.length; i++) {
            if (_cars[i].position == _maxPos) {
                // 이름 연결 헬퍼 함수 호출
                result = _appendName(result, _cars[i].name, isFirst);
                isFirst = false;
            }
        }
        return result;
    }

    // 이름 연결 헬퍼 함수 (쉼표로 구분)
    function _appendName(
        string memory _current,
        string memory _name,
        bool _isFirst
    ) private pure returns (string memory) {
        if (!_isFirst) {
            return string.concat(_current, ", ", _name);
        }
        return string.concat(_current, _name);
    }

    // Java의 .equals()와 동일한 역할
    function equals(
        string memory _a,
        string memory _b
    ) internal pure returns (bool) {
        // 먼저 글자수를 확인해서 불필요한 연산 죽임
        if (bytes(_a).length != bytes(_b).length) {
            return false;
        }

        // 표준 방법: keccak256 해시를 사용하여 내용 비교
        return keccak256(bytes(_a)) == keccak256(bytes(_b));
    }
}
