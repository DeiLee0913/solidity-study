// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.1;

/*
에러 핸들러: require, revert, assert, try/catch
*/

contract lec26 {

    /*
    Solidity 0.8.1 ~ 현재
    - assert:
        • 내부 오류(버그) 또는 불변 조건(invariant) 검사 용도
        • 실패 시 Panic(uint256) 에러 발생
        • 0.8.1 이후부터는 assert 실패 시 남은 gas 환불됨
    Solidity 0.7.x
        • assert 실패 시 gas 환불 없음 (모든 gas 소모)
    */

    // assert(false) 테스트용
    function assertNow() public pure {
        assert(false);
    }

    // revert(): 남은 gas 환불 + 에러 메시지 가능
    function revertNow() public pure {
        revert("error!");
    }

    // require(): 조건 검사 실패 시 revert + gas 환불
    function requireNow() public pure {
        require(false, "occured");
    }

    // 예시: 입력 검증 (성인 체크)
    function onlyAdults(uint256 _age) public pure returns (string memory) {
        if (_age < 19) {
            revert("You are not allowed to buy the cigarette.");
        }
        return "Your payment is succeeded.";
    }
}
