// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Father {
    string public familyName = "Kim";
    string public givenName = "Jung";
    uint256 public money = 100;

    constructor(string memory _givenName) {
        givenName = _givenName;
    }

    function getFamilyName() view public returns(string memory)  {
        return familyName;
    }

    function getGivenName() view public returns(string memory)  {
        return givenName;
    }

    function getMoney() view public returns(uint256)  {
        return money;
    }
}

/* 부모 생성자 호출 방식
    1. 축약형(Implicit form)
    - 부모 생성자에 전달할 인자를 상속 구문(is) 옆에 직접 명시
    - 간단히 표현 가능하지만, 자식 컨트랙트에 별도 초기화 코드가 없을 때 주로 사용
*/

// 축약 버전 부모 생성자 호출: 부모 생성자 호출 인자를 상속 구문에 직접 전달
contract Son is Father("James") {}

/*
    2. 명시형 (Explicit form)
   - 자식 컨트랙트의 constructor 내부에서 부모 생성자를 직접 호출
   - 부모 생성자 인자와 함께 자식 전용 초기화 코드도 추가 가능
*/

// contract Son is Father {
//     constructor() Father("James") {
//         //Son 전용 초기화 코드 추가 가능
//     }
// }
