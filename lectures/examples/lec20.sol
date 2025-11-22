// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
Struct (구조체)

- 구조체(struct)는 여러 개의 변수를 하나의 그룹으로 묶어 관리할 수 있는 사용자 정의 자료형이다.
- 다양한 타입의 데이터를 하나의 단위로 다룰 수 있기 때문에,
  캐릭터 정보, 사용자 프로필, 상품 정보 등 복합 데이터를 표현할 때 자주 사용된다.
  */

contract lec20 {
    // 구조체 Character 정의
    struct Character {
        uint256 age;
        string name;
        string job;
    }

    // 구조체 인스턴스를 생성해서 반환하는 함수(저장하지는 않음)
    // 'pure' 함수이므로 블록체인 상태를 변경하지 않음
    function makeCharacter(
        uint256 _age,
        string memory _name,
        string memory _job
    ) public pure returns (Character memory) {
        return Character(_age, _name, _job);
    }

    // 1. mapping을 이용한 구조체 저장
    mapping(uint256 => Character) public CharacterMapping;
    
    // 2. array를 이용한 구조체 저장
    Character[] public CharacterArray;

    // 구조체(Character)를 mapping에 추가
    function createCharacterMapping(uint256 _key, uint256 _age, string memory _name, string memory _job) public {
        CharacterMapping[_key] = Character(_age, _name, _job);
    }

    // 구조체(Character) mapping에서 조회
    function getCharacterMapping(uint256 _key) public view returns(Character memory) {
        return CharacterMapping[_key];
    }

    //구조체(Character)를 배열에 추가
    function createCharacterArray(uint256 _age, string memory _name, string memory _job) public {
        CharacterArray.push(Character(_age, _name, _job));
    }

    // 구조체(Character)를 배열에서 조회
    function getCharacterArray(uint256 _index) public view returns(Character memory) {
        return CharacterArray[_index];
    }
}
