// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/* 생성자(Constructor)
- 컨트랙트가 배포될 때 단 한 번만 실행되는 특별한 함수
- 주로 상태 변수의 '초기값 설정'에 사용 */

contract A {
    string public name;
    uint256 public age;

    // 생성자: 컨트랙트가 배포될 때 자동으로 실행됨
    constructor(string memory _name, uint256 _age) {
        name = _name;
        age = _age;
    }

    // 상태 변수 변경 함수
    function change(string memory _name, uint256 _age) public {
        name = _name;
        age = _age;
    }
}

/* 다른 컨트랙트에서 생성자 사용하기
- new 키워드로 Person 컨트랙트의 인스턴스를 생성할 때, 생성자의 매개변수(_name, _age)를 함께 전달해야 함
- 인스턴스 생성 시마다 새로운 컨트랙트가 블록체인에 배포되므로 가스 소비가 많을 수 있음
- 블록마다 제한된 가스량을 초과하면 이더리움 생계에 대한 접근 자체가 차단됨
  (이를 최적화하는 패턴 중 하나가 'Clone Factory Pattern') 
*/
contract B {
    // Person 컨트랙트 인스턴스 생성 (생성자 인자 전달)
    A instance = new A("Alice", 52);

    // Person의 정보 변경 함수
    function change(string memory _name, uint256 _age) public {
        instance.change(_name, _age);
    }

    // Person의 현재 정보 조회 함수
    function get() public view returns(string memory, uint256) {
        return (instance.name(), instance.age());
    }
}