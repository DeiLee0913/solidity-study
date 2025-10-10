// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
instance를 사용하는 이유:
한 컨트랙트(예: B)에서 다른 컨트랙트(예: A)의 함수나 변수를 사용하기 위해
해당 컨트랙트의 '인스턴스(복제된 객체)'를 생성해야 함

즉, B 컨트랙트 안에서 A 컨트랙트의 기능을 직접 호출하려면,
먼저 A의 인스턴스를 만들어야 함
*/

contract A {
    uint256 public a = 5;

    function change(uint256 _value) public {
        a = _value;
    }
}

contract B {
    // A 컨트랙트의 인스턴스 생성
    A aInstance = new A();

    // A 컨트랙트의 상태 변수 value를 읽어오기 (읽기 전용이므로 view)
    function getValueFromA() public view returns(uint256) {
        return aInstance.a();
    }

    function updateValueInA(uint256 _value) public {
        aInstance.change(_value);
    }
}