// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec4 {
    /*
    function [이름] ([매개변수]) [접근제어자] returns ([반환할 타입]) {
        [함수 본문]
    }
    */

    uint256 public a = 3;

    // 1. 매개변수와 반환값이 없는 함수: 상태 변수 a를 5로 고정 변경
    function setAtoFive() public {
        a = 5;
    }

    // 2. 매개변수는 있고 반환값이 없는 함수: 입력받은 값으로 a를 변경
    function setA(uint256 _value) public {
        a = _value;
    } 


    // 3. 매개변수와 반환값이 모두 있는 함수: 입력받은 값으로 a를 변경하고 변경된 값 반환
    function setAAndReturn(uint256 _value) public returns (uint256) {
        a = _value;
        return a;
    }
}