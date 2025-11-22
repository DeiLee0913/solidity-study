// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/* mapping의 기본적인 접근 제한 구조 예시

- mapping은 보통 'private'으로 선언하고,
  외부에서는 getter 함수를 통해 읽기만 가능하게 한다.
- setter는 public 대신 internal로 두어
  다른 내부 함수만 수정할 수 있도록 제한할 수 있다.
*/

contract Mapping {
    mapping(string => uint256) private priceList;

    // Getter: 외부 접근 가능, 누구나 가격을 조회할 수 있음(읽기 전용)
    function getPrice(string memory _item) public view returns (uint256) {
        return priceList[_item];
    }

    // Setter: 내부 전용, internal 키워드로 컨트랙트 내부에서만 호출 가능하게 함
    function _setPrice(string memory _item, uint256 _price) internal {
        priceList[_item] = _price;
    }

     // public 함수가 내부 setter를 호출하여 수정
    function updateSampleData() public {
        _setPrice("apple", 1000);
        _setPrice("banana", 1500);
    }
}