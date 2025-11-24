// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IRace.sol";
import "../libraries/CarStruct.sol";
import "../libraries/RandomMoveLibrary.sol";

contract Race is IRace {
    using CarStruct for CarStruct.Car;
    using RandomMoveLibrary for uint256;

    function moveCar(CarStruct.Car storage _car) internal override {
        uint256 randomValue = RandomMoveLibrary.generatePseudoRandom();

        if (randomValue.shouldMove()) {
            _car.position++;
        }
    }

    function determineWinners(
        CarStruct.Car[] storage _cars
    ) internal view override returns (string memory) {
        uint256 maxPos = _findMaxPosition(_cars);
        return _buildWinnerText(_cars, maxPos);
    }

    function _findMaxPosition(
        CarStruct.Car[] storage _cars
    ) private view returns (uint256) {
        uint256 maxPos = 0;
        for (uint256 i = 0; i < _cars.length; i++) {
            maxPos = _updateMax(maxPos, _cars[i].position);
        }
        return maxPos;
    }

    function _updateMax(
        uint256 _currentMax,
        uint256 _pos
    ) private pure returns (uint256) {
        if (_pos > _currentMax) {
            return _pos;
        }
        return _currentMax;
    }

    function _buildWinnerText(
        CarStruct.Car[] storage _cars,
        uint256 _maxPos
    ) private view returns (string memory) {
        string memory result = "";
        bool isFirst = true;

        for (uint256 i = 0; i < _cars.length; i++) {
            if (_cars[i].position == _maxPos) {
                result = _appendName(result, _cars[i].name, isFirst);
                isFirst = false;
            }
        }
        return result;
    }

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

    // // 두 바이트 배열을 연결하는 헬퍼 함수
    // // 문자열 연결을 위해 어셈블리 사용 (가스 효율성 목적)
    // function _concatenateBytes(bytes memory a, bytes memory b) private pure returns (bytes memory) {
    //     bytes memory c = new bytes(a.length + b.length);
    //     assembly {
    //         mstore(add(c, 32), a)
    //         mstore(add(add(c, 32), mload(a)), b)
    //     }
    //     return c;
    //
}
