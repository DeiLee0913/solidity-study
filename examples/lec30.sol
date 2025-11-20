// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec30 {

    /*
    modifier 개념
    - 특정 조건을 함수 실행 전/후에 강제하기 위해 사용하는 기능
    - _; 위치가 "원래 함수(body)가 실행될 위치"를 의미
    */

    //    1) 파라미터가 없는 modifier

    // 파라미터가 없으면 괄호 생략 가능
    modifier onlyAdults {
        revert("You are not allowed to pay for the cigarette.");
        _;
        // _ 은 원래 함수 코드가 실행되는 위치
        // 하지만 위에서 revert 했기 때문에 실제로 함수는 실행되지 않음
    }

    function BuyCigarette() public onlyAdults returns (string memory) {
        return "Your payment is succeeded.";  // 이 코드는 실행되지 않음
    }


    //    2) 파라미터가 있는 modifier

    modifier onlyAdults2(uint256 _age) {
        require(_age > 18, "You are not allowed to pay for the cigarette.");
        _;
    }

    function BuyCigarette2(uint256 _age)
        public
        onlyAdults2(_age)
        returns (string memory)
    {
        return "Your payment is succeeded.";
    }


//    3) modifier 실행 순서 예제
//      - modifier 안에서 _; 앞/뒤에 실행할 수 있는 코드 가능

    uint256 public num = 5;

    modifier numChange {
        _;          // 먼저 함수 본문 실행
        num = 10;   // 함수 실행 후 최종적으로 num을 10으로 변경
    }

    function numChangeFunction() public numChange {
        num = 15;   // 먼저 실행됨 → 이후 modifier가 num = 10 으로 덮어씀
    }
}
