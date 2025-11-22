// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
Solidity에서 mapping과 array는 '값 변경'이 아니라 '업데이트' 개념으로 동작한다.
즉, 새로운 변수에 같은 이름으로 다시 할당하는 것이 아니라,
기존에 선언된 자료구조의 특정 인덱스나 키를 직접 수정해야 값이 반영된다.

예를 들어:
- mapping: numMap[key] = newValue;
- array:   numArray[index] = newValue;

만약 mapping이나 array 자체를 새로 선언하거나 재할당하려고 하면,
컴파일 에러가 발생하거나 기존 데이터가 유지되지 않는다.
*/

contract lec19 {
    mapping(uint256 => uint256) public numMap;
    uint256[] public newArray;
    uint256 public num = 100;

    // mapping의 특정값 업데이트
    function numMappAdd() public {
        numMap[0] = num;    // 기존 key(0)d에 새로운 값 저장
    }

    // 배열의 특정 인덱스 값 업데이트
    function updateArray() public {
        // 배열에 값이 없는 상태에서 인덱스 접근 시 오류가 발생하므로
        // 먼저 요소를 추가(push)한 뒤 값을 갱신하는 것이 안전
        if (newArray.length == 0) {
            newArray.push(num);
        } else {
            newArray[0] = num;  // 인덱스의 0의 값 수정
        }

        newArray[0] = num;
    }
}