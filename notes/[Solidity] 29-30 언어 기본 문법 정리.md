# [Solidity] 29-30: 언어 기본 문법 정리

## 반환 변수(Return Variables)

### 반환 변수를 미리 선언하는 방식

- 반환 변수는 *이미 선언된 상태*로 함수 내부에 존재
- 지역 변수처럼 자료형을 다시 쓰지 않고 바로 값만 대입
- 반환 변수를 모두 설정했다면 `return` 자체도 생략 가능
- 같은 타입의 반환값이 여러 개일 때 가독성이 좋아짐

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec29 {

    /*
    반환 변수(return variables)를 미리 선언할 때:
    - 같은 자료형의 반환값이 많으면 변수명을 명시해 가독성을 높일 수 있음
    - 반환 변수는 함수 내부에서 자동으로 저장 공간이 생성되므로
      자료형 없이 바로 대입할 수 있다.
    */

    // 반환 변수 여러 개 선언
    function add(uint256 _num1, uint256 _num2) 
        public 
        pure 
        returns (uint256 total, uint256 height, uint256 age, uint256 weight)
    {
        // 반환 변수 total은 이미 선언되어 있으므로 자료형 없이 대입
        total = _num1 + _num2;
        height = 0;
        age = 0;
        weight = 0;

        // 반환 변수를 모두 채웠다면 return 생략 가능
        // 하지만 명시적으로 쓰는 것도 허용됨
        return (total, height, age, weight);
    }

    // 반환 변수 하나만 있는 경우
    function add2(uint256 _num1, uint256 _num2) 
        public 
        pure 
        returns (uint256 total)
    {
        // 반환 변수 total은 이미 선언됨 → 자료형 없이 바로 값 할당
        total = _num1 + _num2;
        return total;
    }
}
```

## Modifier

함수 실행 전에 **공통적으로 실행해야 하는 조건/코드**를 재사용하기 위한 기능

- 공통 로직을 함수 실행 전/후에 강제할 때 사용
- `_` 위치가 실제 함수 본문이 들어갈 자리
- modifier 안에서 revert/require로 조건 체크 가능
- 파라미터 전달 가능
- 실행 전/후 처리 로직 작성 가능

```solidity
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

```