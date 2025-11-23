// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Father {
    uint256 public fatherMoney = 100;

    function getFatherName() public pure returns(string memory)  {
        return "KimJung";
    }

    function getMoney() view public virtual returns(uint256)  {
        return fatherMoney;
    }
}

contract Mother {
    uint256 public motherMoney = 200;

    function getMotherName() public pure returns(string memory)  {
        return "Leesol";
    }

    function getMoney() view public virtual returns(uint256)  {
        return motherMoney;
    }
}

// 같은 이름의 함수를 가진 두 개 이상의 contract 상속 시
// 자식 contract해서 오버라이딩 필수
contract Son is Father, Mother {
    function getMoney() public view override(Father, Mother) returns(uint256)  {
        return fatherMoney + motherMoney;
    }
}