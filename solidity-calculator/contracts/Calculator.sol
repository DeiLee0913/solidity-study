// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/ICalculator.sol";
import "./interfaces/IResultStorage.sol";
import "./interfaces/IAdder.sol";
import "./libraries/StringSplitter.sol";

contract Calculator is ICalculator {
    IResultStorage public store;
    IAdder public adder;

    // 라이브러리 연결
    using StringSplitter for string;

    constructor(address _storeAddress, address _adderAddress) {
        // TODO: address(0) 또는 코드 주입 검증 로직 추가 가능
        store = IResultStorage(_storeAddress);
        adder = IAdder(_adderAddress);
    }

    // 핵심 계산 로직
    function calculate(
        string memory input
    ) public view override returns (uint256 sum) {
        if (bytes(input).length == 0) {
            return 0;
        }

        // 구분자 대상 및 문자열 추출
        (string memory delimiters, string memory targetString) = input
            .extractDelimiterAndTarget();

        // 문자열 분리 및 파싱
        uint256[] memory numbers = _splitAndParse(targetString, delimiters);

        // 합계 계산
        sum = adder.add(numbers);

        return sum;
    }

    // 트랜잭션 및 저장 로직(상태 변경)
    function calculateAndStore(
        string memory input
    ) public returns (uint256 sum) {
        sum = calculate(input);

        store.setResult(sum);
        return sum;
    }

    // 주어진 bytes 배열에서 start부터 length만큼의 바이트를 추출하여 새로운 string으로 반환
    function _sliceToString(
        bytes memory b,
        uint256 start,
        uint256 length
    ) private pure returns (string memory) {
        if (length == 0 || start + length > b.length) {
            return "";
        }

        bytes memory result = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = b[start + i];
        }
        return string(result);
    }

    // 결과 조회
    function getResult() public view returns (uint256) {
        return store.getResult();
    }

    function _splitAndParse(
        string memory targetString,
        string memory delimiters
    ) private pure returns (uint256[] memory numbers) {
        bytes memory targetBytes = bytes(targetString);
        bytes memory delimiterBytes = bytes(delimiters);

        if (targetBytes.length == 0) {
            return new uint256[](0);
        }

        // 토큰 개수 세기 로직
        uint256 count = 1;
        for (uint256 i = 0; i < targetBytes.length; i++) {
            for (uint256 j = 0; j < delimiterBytes.length; j++) {
                if (targetBytes[i] == delimiterBytes[j]) {
                    count++;
                    break;
                }
            }
        }

        numbers = new uint256[](count);
        uint256 tokenStart = 0;
        uint256 numIndex = 0;

        for (uint256 i = 0; i < targetBytes.length; i++) {
            bool isDelimiter = false;
            for (uint256 j = 0; j < delimiterBytes.length; j++) {
                if (targetBytes[i] == delimiterBytes[j]) {
                    isDelimiter = true;
                    break;
                }
            }

            if (isDelimiter) {
                if (i > tokenStart) {
                    uint256 tokenLength = i - tokenStart;
                    string memory token = _sliceToString(
                        targetBytes,
                        tokenStart,
                        tokenLength
                    );

                    numbers[numIndex] = _parseUint(token);
                    numIndex++;
                }
                tokenStart = i + 1;
            }
        }

        if (targetBytes.length > tokenStart) {
            uint256 lastTokenLength = targetBytes.length - tokenStart;
            string memory token = _sliceToString(
                targetBytes,
                tokenStart,
                lastTokenLength
            );

            numbers[numIndex] = _parseUint(token);
        }

        return numbers;
    }

    // 문자열을 uint256으로 변환(->양수)하며, 비숫자 문자 포함 여부 및 음수 여부 검증
    function _parseUint(string memory s) private pure returns (uint256) {
        bytes memory b = bytes(s);
        uint256 res = 0;

        for (uint256 i = 0; i < b.length; i++) {
            if (b[i] >= 0x30 && b[i] <= 0x39) {
                res = res * 10 + (uint256(uint8(b[i])) - 0x30);
            } else {
                revert(
                    "IllegalArgumentException: Input token contains non-digit characters."
                );
            }
        }

        return res;
    }
}
