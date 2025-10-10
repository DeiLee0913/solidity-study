// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Father {
    string public familyName = "Kim";
    string public givenName = "Jung";
    uint256 public money = 100;

    constructor(string memory _givenName) {
        givenName = _givenName;
    }

    function getFamilyName() view public returns(string memory)  {
        return familyName;
    }

    function getGivenName() view public returns(string memory)  {
        return givenName;
    }

    // 오버라이드(override) 가능한 함수에는 반드시 `virtual` 키워드를 붙인다.
    function getMoney() view public virtual returns(uint256)  {
        return money;
    }
}

contract Son is Father("James") {
    uint256 public earning = 0;

    function work() public {
        earning += 100;
    }

    // 부모 함수를 재정의(override)하는 함수에는 반드시 `override` 키워드를 붙인다.
    function getMoney() view public override returns(uint256)  {
        return money + earning;
    }
}