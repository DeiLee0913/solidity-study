// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
다중 상속(Multiple Inheritance)과 super 호출 순서
- Solidity는 다중 상속 시 'C3 Linearization' 방식을 따른다.
- super 키워드를 사용하면, 상속 순서의 '역순'으로 부모 컨트랙트의 함수가 호출된다.
*/

contract Father {
    event FatherName(string name);
    function who() public virtual {
        emit FatherName("KimDaeho");
    }
}

contract Mother {
    event MotherName(string name);
    function who() public virtual {
        emit MotherName("Leesol");
    }
}

contract Son is Father, Mother {
    function who() public override(Father, Mother) {
        // super.who() → 상속 순서의 역순(Mother → Father)으로 실행
        super.who();
    }
}