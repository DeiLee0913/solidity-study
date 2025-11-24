// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library StringUtils {
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
