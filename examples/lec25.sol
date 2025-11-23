// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.8.0;

/*
Solidity 0.4.22 ~ 0.7.x 에러 처리

- assert:
    • 내부적 오류(버그)를 잡기 위한 용도
    • 조건이 false면 트랜잭션을 revert하지만, 남은 gas를 환불하지 않고 모두 소모함
    • 주로 개발·테스트용 또는 절대 실패하면 안 되는 불변 조건 검사에 사용

- revert:
    • 조건 없이 즉시 에러 발생
    • 남은 gas 전부 환불
    • 에러 메시지 작성 가능
    • require로 표현하기 어려운 복잡한 조건에서 사용하기 좋음

- require:
    • 특정 조건이 false일 때 revert
    • 남은 gas 환불
    • 에러 메시지 작성 가능
    • 입력값 검증, 권한 체크 같은 일반적인 조건문에서 사용
*/

contract lec25 {
    // assert(false): gas 환불 없음 → 높은 비용
    function assertNow() public pure {
        assert(false);
    }

    // revert(): 즉시 에러 발생 + gas 환불
    function revertNow() public pure {
        revert("error!!");
    }

    // require(): 조건 검사 + 실패 시 revert + gas 환불
    function requireNow() public pure {
        require(false, "occured");
    }

    // 예시: 나이 검증
    function onlyAdults(uint256 _age) public pure returns (string memory) {
        if (_age < 19) {
            revert("You are not allowed to buy the cigarette.");
        }
        return "Your payment is succeeded.";
    }
}
