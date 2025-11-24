// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StringUtils.sol";

library ValidationLibrary {
    using StringUtils for string;

    uint256 internal constant MAX_NAME_LENGTH = 5;
    uint256 internal constant MAX_CAR_COUNT = 10;

    function validateTryCount(uint256 _count) internal pure {
        if (_count == 0) {
            revert("Try count must be greater than 0");
        }
    }

    function validateCarNames(string[] memory _names) internal pure {
        if (_names.length <= 1) {
            revert("At least 2 cars are required");
        }

        // 이름 중복 확인시 이중 for문을 사용하고 있으므로 자동차의 최대 개수를 10개로 제한
        if (_names.length > MAX_CAR_COUNT) {
            revert("Car count cannot exceed 10");
        }

        // (O(N^2) 로직 사용) 이름 형식 및 중복 검증
        _validateNamesAndDuplicates(_names);
    }

    function _validateNamesAndDuplicates(string[] memory _names) private pure {
        // 이미 확인된 이름의 keccak256 해시 값을 저장할 임시 배열
        bytes32[] memory seenHashes = new bytes32[](_names.length);
        uint256 seenCount = 0;

        for (uint256 i = 0; i < _names.length; i++) {
            string memory currentName = _names[i];

            _validateSingleName(currentName);

            bytes32 currentHash = keccak256(bytes(currentName));

            for (uint256 j = 0; j < seenCount; j++) {
                if (seenHashes[j] == currentHash) {
                    revert("Duplicate car name found");
                }
            }

            seenHashes[seenCount] = currentHash;
            seenCount++;
        }
    }

    function _validateSingleName(string memory _name) private pure {
        bytes memory nameBytes = bytes(_name);

        if (nameBytes.length == 0) {
            revert("Name cannot be empty");
        }
        if (nameBytes.length > MAX_NAME_LENGTH) {
            revert("Name cannot exceed 5 characters");
        }
    }
}
