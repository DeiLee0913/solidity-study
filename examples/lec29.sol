// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec29 {

    /*
    반환 변수(return variables)를 미리 선언할 때:
    - 같은 자료형의 반환값이 많으면 변수명을 명시해 가독성을 높일 수 있음
    - 반환 변수는 함수 내부에서 자동으로 저장 공간이 생성되므로
      자료형 없이 바로 대입할 수 있다.
    */

    // 반환 변수 여러 개 선언
    function add(uint256 _num1, uint256 _num2) 
        public 
        pure 
        returns (uint256 total, uint256 height, uint256 age, uint256 weight)
    {
        // 반환 변수 total은 이미 선언되어 있으므로 자료형 없이 대입
        total = _num1 + _num2;
        height = 0;
        age = 0;
        weight = 0;

        // 반환 변수를 모두 채웠다면 return 생략 가능
        // 하지만 명시적으로 쓰는 것도 허용됨
        return (total, height, age, weight);
    }


    // 반환 변수 하나만 있는 경우
    function add2(uint256 _num1, uint256 _num2) 
        public 
        pure 
        returns (uint256 total)
    {
        // 반환 변수 total은 이미 선언됨 → 자료형 없이 바로 값 할당
        total = _num1 + _num2;
        return total;
    }
}