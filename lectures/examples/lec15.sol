// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Father {
    event FatherName(string name);
    function who() public virtual {
        emit FatherName("KimDaeho");
    }
}

contract Son is Father {
    event sonName(string name);
    function who() public override {
        // 부모(Father)의 who() 함수 실행
        super.who();

        // 자신의 이벤트 추가 실행       
        emit sonName("KimJin");
    }
}