// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/* Mapping
- mapping은 key-value 쌍으로 데이터를 저장하는 자료구조.
- key를 통해 value에 직접 접근하는 방식.
- 배열과 달리 '순서'나 '길이(length)'를 알 수 없음.
- key는 중복될 수 없으며, 존재하지 않는 key를 조회하면 기본값(default value)을 반환함.
*/

// mapping은 키와 value로 구성되어 있기 때문에 Length를 알 수 없음
contract lec17 {
    /* mapping 정의 형식
    mapping([key 자료형] => [value 자료형]) [가시성] [이름];
    */

    mapping(uint256 => uint256) private ageList;
    mapping(string => uint256) private priceList;
    mapping(uint256 => string) private nameList;

    // ageList: uint256 -> uint256
    function setAgeList(uint256 _index, uint256 _age) public {
        ageList[_index] = _age;
    }

    function getAge(uint256 _index) public view returns(uint256) {
        return ageList[_index];
    }

    // nameList: unint256 -> string
    function setNameList(uint256 _index, string memory _name) public {
        nameList[_index] = _name;
    }

    function getNameList(uint256 _index) public view returns(uint256) {
        return ageList[_index];
    }

    function setPriceList(string memory _itemName, uint256 _price) public {
        priceList[_itemName] = _price;
    }

    function getPriceList(string memory _index) public view returns(uint256) {
        return priceList[_index];
    }
}