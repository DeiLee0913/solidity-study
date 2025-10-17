// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/* 배열(Array)

- mapping과 달리 배열은 length를 확인할 수 있음.
- 배열을 순환(iteration)하며 조작하는 기능은 DDoS 공격에 취약하므로,
  Solidity에서는 array보다 mapping을 더 선호.
- 배열은 가능한 한 크기에 제한을 두고 사용하는 것이 좋음.
*/

contract lec18 {
    // 동적 배열(길이가 유동적으로 변함)
    uint256[] public ageArray;
    // 고정 크기 배열(길이가 10으로 고정됨)
    uint256[10] public ageFixedSizeArray;
    // 묹열 배열 선언과 동시에 초기화
    string[] public nameAray = ["Kal", "Jhon", "Kerri"];

    // 배열의 길이를 반환하는 함수
    function AgeLength() public view returns(uint256) {
        return ageArray.length;
    }

    // 배열의 끝에 새로운 값을 추가하는 함수
    // 인덱스는 0부터 시작
    function AgePush(uint256 _age) public {
        ageArray.push(_age);
    }

    // 특정 인덱스의 값을 반환하는 함수
    // 인덱스가 배열 범위를 벗어나면 오류 발생
    function AgeGet(uint256 _index) public view returns(uint256) {
        return ageArray[_index];
    }

    // 배열의 마지막 요소를 제거
    // 가장 마지막 인덱스의 값을 삭제하고 배열의 길이를 1 줄임
    function AgePop() public {
        ageArray.pop();
    }

    // 특정 인덱스의 값을 기본값(0)으로 초기화하는 함수
    // 따라서 배열의 길이는 줄어들지 않음    function AgeDelete(uint256 _index) public {
    function AgeDelete(uint256 _index) public {
        delete ageArray[_index];
    }

    // 특정 인덱스의 값을 다른 값으로 변경하는 함수
    // 인덱스가 범위를 벗어나면 오류 발생
    function AgeChange(uint256 _index, uint256 _age) public {
        ageArray[_index] = _age;
    }
    
}