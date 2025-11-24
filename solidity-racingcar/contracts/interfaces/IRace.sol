// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/CarStruct.sol";

abstract contract IRace {
    using CarStruct for CarStruct.Car;

    // 단일 자동차의 이동 여부를 결정하고 자동차 업데이트
    function moveCar(CarStruct.Car storage _car) internal virtual;

    // 경주 종료 후 우승자를 결정하고 쉼표로 구분된 문자열로 반환
    function determineWinners(
        CarStruct.Car[] storage _cars
    ) internal view virtual returns (string memory);
}
