// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/CarStruct.sol";
import "../libraries/ValidationLibrary.sol";
import "./Race.sol";
import "../logic/RandomMoveLogic.sol";

contract CarRacingGame is Race {
    using CarStruct for CarStruct.Car;

    CarStruct.Car[] private cars;

    // 생성자를 통해 MoveLogic 주소를 받아서 Race 계약으로 전달
    // 배포 시 RandomMoveLogic을 배포하고 그 주소를 여기에 주입
    constructor(address _moveLogicAddress) Race(_moveLogicAddress) {}

    // 입력받아 게임을 시작하는 메인 함수
    function startRace(
        string[] memory _names,
        uint256 _tryCount
    ) public returns (string memory) {
        // 1. 검증
        ValidationLibrary.validateTryCount(_tryCount);
        ValidationLibrary.validateCarNames(_names);

        // 2. 초기화
        delete cars;
        for (uint256 i = 0; i < _names.length; i++) {
            cars.push(CarStruct.Car({name: _names[i], position: 0}));
        }

        // 3. 경주 진행
        for (uint256 i = 0; i < _tryCount; i++) {
            for (uint256 j = 0; j < cars.length; j++) {
                moveCar(cars[j]); // 상속받은 Race의 함수 사용
            }
        }

        // 4. 결과 반환
        return determineWinners(cars);
    }
}
