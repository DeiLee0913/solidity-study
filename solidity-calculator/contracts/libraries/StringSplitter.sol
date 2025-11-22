// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// 문자열 파싱 및 구분자 추출 유틸리티
library StringSplitter {
    string private constant DEFAULT_DELIMITERS = ",;";

    // 커스텀 구분자 패턴: "//"로 시작하고 "\n" 전에 위치
    string private constant CUSTOM_DELIMITER_PREFIX = "//";
    uint256 private constant CUSTOM_DELIMITER_PREFIX_LENGTH = 2;
    uint256 private constant CUSTOM_DELIMITER_NEWLINE_LENGTH = 1;

    /**
     * @dev 주어진 bytes 배열에서 start부터 length만큼의 바이트를 추출하여 새로운 string으로 반환합니다.
     * bytes memory 배열 슬라이싱을 대체합니다.
     */
    function _sliceToString(
        bytes memory b,
        uint256 start,
        uint256 length
    ) private pure returns (string memory) {
        // length가 0이거나 배열 범위를 벗어나는 경우 처리
        if (length == 0 || start + length > b.length) {
            return "";
        }

        bytes memory result = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = b[start + i];
        }
        return string(result);
    }

    // 입력 문자열에서 커스텀 구분자를 추출하고 실제 계산할 문자열 부분을 반환
    function extractDelimiterAndTarget(
        string memory input
    )
        internal
        pure
        returns (string memory delimiter, string memory targetString)
    {
        bytes memory inputBytes = bytes(input);

        // 1. 커스텀 구분자 패턴 확인: "//"로 시작하는지
        if (inputBytes.length >= CUSTOM_DELIMITER_PREFIX_LENGTH) {
            // keccak256 슬라이싱 대신, 문자열 비교를 위해 명시적으로 추출
            string memory prefix = _sliceToString(
                inputBytes,
                0,
                CUSTOM_DELIMITER_PREFIX_LENGTH
            );

            if (
                keccak256(bytes(prefix)) ==
                keccak256(bytes(CUSTOM_DELIMITER_PREFIX))
            ) {
                // 2. "\n" 위치 찾기
                for (
                    uint256 i = CUSTOM_DELIMITER_PREFIX_LENGTH;
                    i < inputBytes.length;
                    i++
                ) {
                    if (inputBytes[i] == 0x0A) {
                        // '\n'

                        // 커스텀 구분자 추출 (//와 \n 사이)
                        uint256 delimiterLength = i -
                            CUSTOM_DELIMITER_PREFIX_LENGTH;
                        delimiter = _sliceToString(
                            inputBytes,
                            CUSTOM_DELIMITER_PREFIX_LENGTH,
                            delimiterLength
                        );

                        // 기본 구분자에 커스텀 구분자 추가
                        delimiter = string(
                            abi.encodePacked(DEFAULT_DELIMITERS, delimiter)
                        );

                        // 실제 계산 대상 문자열 추출 (\n 다음부터)
                        uint256 targetStart = i +
                            CUSTOM_DELIMITER_NEWLINE_LENGTH;
                        uint256 targetLength = inputBytes.length - targetStart;
                        targetString = _sliceToString(
                            inputBytes,
                            targetStart,
                            targetLength
                        );

                        return (delimiter, targetString);
                    }
                }
                // 커스텀 구분자 패턴은 찾았으나, "\n"이 없는 경우 -> 잘못된 형식 revert
                revert(
                    "Invalid input format for custom delimiter: '\\n' is missing."
                );
            }
        }

        // 커스텀 구분자 패턴이 없거나, 조건에 맞지 않는 경우 기본 구분자 사용
        return (DEFAULT_DELIMITERS, input);
    }
}
