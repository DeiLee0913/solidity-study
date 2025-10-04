// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec6 {
    /*
    view: 상태 변수(state variable)들을 읽을 수 있으나 변경 불가능
    pure:   상태 변수를 읽거나 변경할 수 없음 (함수 내부 연산만 가능)
    (view, pure 모두 미사용 시): 상태 변수를 읽고 변경할 수 있음 → 트랜잭션 발생
    */

    uint256 public a = 1;

    // 1. view 함수: 상태 변수를 읽을 수 있으나, 변경 불가능
    function read_view() public view returns (uint256) {
        return a + 2;
    }

    // 2. pure 함수: 상태 변수를 읽거나 변경할 수 없음
    function read_pure() public pure returns (uint256) {
        uint256 b = 1;
        return 4 + 2 + b;
    }

    // 3. 기본 함수: 상태 변수를 읽고 변경 가능 (트랜잭션 발생)
    function read() public returns (uint256) {
        a = 13;
        return a;
    }
}