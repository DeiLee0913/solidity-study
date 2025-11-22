// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/* Solidity Event의 indexed 키워드
- 이벤트(event)는 블록체인 로그에 데이터를 저장하기 위한 기능
- indexed 키워드는 이벤트의 특정 매개변수를 "검색 가능한 필드"로 지정
  (즉, 이벤트를 필터링하거나 특정 값으로 조회할 수 있도록 함)
*/
contract lec14 {
    // indexed 없는 이벤트 → 단순 로그로 저장 (검색 불가)
    event numberTracker(uint256 num, string st);
    // indexed 있는 이벤트 → num 필드를 색인(index)으로 지정 (검색 가능)
    event numberTracker2(uint256 indexed num, string str);

    uint256 num = 0;
    // 이벤트 발생 함수
    function PushEvent(string memory _str) public {
        emit numberTracker(num, _str);
        emit numberTracker2(num, _str);
        num++;
    }
}