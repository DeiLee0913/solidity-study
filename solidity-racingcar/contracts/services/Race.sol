// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IRace.sol";
import "../interfaces/IMoveLibrary.sol";
import "../libraries/CarStruct.sol";
import "../libraries/StringUtils.sol";

contract Race is IRace {
    using CarStruct for CarStruct.Car;

    // 이동 로직 계약 주소 저장
    IMoveLibrary private moveLogic;

    // 생성자를 통해 이동 로직 계약 주소를 주입받음 (의존성 주입)
    constructor(address _moveLogicAddress) {
        moveLogic = IMoveLibrary(_moveLogicAddress);
    }

    function moveCar(CarStruct.Car storage _car) internal override {
        if (moveLogic.shouldMove()) {
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
