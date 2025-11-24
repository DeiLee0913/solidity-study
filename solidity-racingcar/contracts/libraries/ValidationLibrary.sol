// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StringUtils.sol";

library ValidationLibrary {
    using StringUtils for string;

    uint256 internal constant MAX_NAME_LENGTH = 5;

    function validateTryCount(uint256 _count) internal pure {
        if (_count == 0) {
            revert("Try count must be greater than 0");
        }
    }

    function validateCarNames(string[] memory _names) internal pure {
        if (_names.length <= 1) {
            revert("At least 2 cars are required");
        }
        _validateEachNameAndDuplicate(_names);
    }

    function _validateEachNameAndDuplicate(
        string[] memory _names
    ) private pure {
        for (uint256 i = 0; i < _names.length; i++) {
            _validateSingleName(_names[i]);
            _checkDuplicate(_names, i);
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

    function _checkDuplicate(
        string[] memory _names,
        uint256 _currentIndex
    ) private pure {
        for (uint256 j = _currentIndex + 1; j < _names.length; j++) {
            if (_names[_currentIndex].equals(_names[j])) {
                revert("Duplicate car name found");
            }
        }
    }
}
