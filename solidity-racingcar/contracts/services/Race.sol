// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IRace.sol";
import "../libraries/CarStruct.sol";
import "../libraries/RandomMoveLibrary.sol";
import "../libraries/StringUtils.sol";

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
        return StringUtils.buildWinnerText(_cars, maxPos);
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
}
