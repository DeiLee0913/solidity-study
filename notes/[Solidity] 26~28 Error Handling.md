# [Solidity] 26~28: 에러 핸들링

## 에러 핸들링 키워드

Solidity에서 에러를 발생시키고 트랜잭션을 되돌리는 방법은 다음과 같음

- **require**
- **revert**
- **assert**
- (0.6.0~) try/catch

이 키워드들은 **조건 검증**, **상태 롤백**, **gas 환불 여부**, **버그 체크** 등 다양한 용도로 사용되며, 특히 Solidity 0.8.x 버전에서 에러 처리 방식이 변경된 부분이 주요점

### require

**역할:** 조건을 검사하고, false일 경우 트랜잭션을 revert

**특징:**

- revert와 동일하게 **남은 gas 환불됨**
- 메시지 전달 가능 → 디버깅에 유리

```solidity
require(condition, "error message");
```

- 주로 다음 용도:
    - 입력값 검증
    - 권한 체크 (`msg.sender == owner`)
    - 외부 호출 값 검증

### revert

**역할:** 조건 없이 즉시 revert를 발생시킴

**특징:**

- require와 동일하게 **남은 gas 환불됨**
- 메시지 전달 가능
- 복잡한 조건문에서 효율적 (require로 표현 어려울 때)

```solidity
if (somethingWrong) {
    revert("error!");
}
```

### assert (버전별 동작 차이 중요)

- Solidity 0.7.x 이전
    - **assert 실패 시 gas 환불 없음**
    - 남은 gas 전부 소모 → 매우 비쌈
    - 내부적 에러(버그) 체크에만 사용해야 함
    - 실무에서는 잘 사용되지 않음 (gas 낭비 심각)

- Solidity 0.8.1 이후
    - 언어 차원에서 안전성 강화
    - **assert 실패 시 남은 gas 환불됨**
    - `Panic(uint256)` 오류 타입으로 처리됨
    - 여전히 “개발자의 실수”를 잡기 위한 용도

### 성인 인증 예시 (require vs revert)

둘 다 동일한 동작을 하지만 상황에 따라 선택

- 간단한 조건 → require
- 여러 조건에서 분기 처리 → revert가 더 명확함

### revert 버전

```solidity
if (_age < 19) {
    revert("Not allowed");
}
```

### require 버전

```solidity
require(_age >= 19, "Not allowed");
```

```solidity
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

```

```solidity
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

```

## try-catch

- try/catch의 목적
    - 외부 호출 실패로 인해 프로그램이 전체 중단되는 것을 방지
    - 실패 상황을 catch 블록에서 직접 처리해 안정적인 흐름 유지

### Solidity의 try/catch는 EVM 호출(Result)을 잡는 문법

- Solidity의 `try/catch`는  **외부 스마트 컨트랙트 호출** 또는 **새로운 컨트랙트 생성** 시 발생할 수 있는 오류를 잡아내기 위한 문법
- try/catch **내부에서** 발생한 require/revert/assert는 **catch로 잡을 수 없음**
    
    즉, try 블록 내부에서 직접 `require`, `revert`, `assert`를 사용하면 **바로 revert**되며 catch가 작동하지 않음
    
- try/catch **외부에서 호출한 함수**에서 발생한 오류는 catch로 잡을 수 있음
    
    ```solidity
    try externalContract.func()
    → 외부 호출 결과 실패(status=false)
    → catch 실행됨
    ```
    

### catch Error(string memory reason)

- `require()` 또는 `revert()`에 의해 발생한 일반적인 오류 처리
- 오류 메시지 문자열(reason)을 받을 수 있음

```solidity
catch Error(string memory reason) { ... }
```

### catch (bytes memory lowLevelData)

- revert reason 없는 **로우 레벨 에러**
- low-level call, delegatecall 등에서 발생하는 원시 EVM 오류를 잡음

```solidity
catch (bytes memory lowLevelData) { ... }
```

### catch Panic(uint256 errorCode)

- **assert 실패** 또는 **언어 레벨의 치명적 에러**를 잡을 때 사용
- Solidity 0.8.1 이상에서 지원

```solidity
catch Panic(uint256 errorCode) { ... }
```

대표적인 Panic 코드:

| errorCode | 의미 |
| --- | --- |
| 0x01 | assert(false) |
| 0x11 | 산술 오버플로우 / 언더플로우 |
| 0x12 | 0으로 나누기 |
| 0x21 | enum 범위 초과 |
| 0x31 | 빈 배열 pop() |
| 0x32 | 배열 인덱스 out of bounds |
| 0x41 | 메모리 과다 할당 |

## try/catch의 사용 시점(=solidity의 외부 호출 시점)

### 외부 스마트 컨트랙트 함수 호출

```solidity
try otherContract.func() returns (...) { ... }
catch { ... }
```

이때 otherContract.func()가 실패하면 catch가 처리

### 다른 스마트 컨트랙트 생성(new Contract())

```solidity
try new Contract(args) returns (...) { ... }
catch { ... }
```

생성자에서 revert가 나면 catch가 처리

### this를 통한 내부 함수 호출 (external 함수만)

- 내부 함수 직접 호출은 catch 불가 → 반드시 external 함수여야 함
- this를 붙이면 자기 자신도 **외부 호출처럼 변함**→ 그래서 catch 가능

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
try / catch 정리

1. try/catch 기본 개념
- 외부 스마트 컨트랙트 호출 또는 new로 컨트랙트 생성 시 사용 가능
- 오류가 발생해도 프로그램이 중단되지 않고 catch 블록에서 처리 가능

 주의:
- try/catch 내부에서 발생한 require/revert/assert는 catch로 잡지 못함
- try/catch 외부에서 발생한 revert/require/assert → catch로 잡을 수 있음

2. catch 종류 (3가지)

(1) catch Error(string memory reason)
    - revert() 또는 require() 에서 발생한 에러를 잡음

(2) catch Panic(uint256 errorCode)
    - assert 실패 또는 언어 레벨의 Panic 오류
    - Solidity 0.8.1+ 에서 추가
    - 주요 panic 코드:
        0x01: assert false
        0x11: 산술 overflow/underflow
        0x12: 0으로 나누기
        0x21: enum 변환 오류
        0x31: 빈 배열에서 pop()
        0x32: 배열 인덱스 out of bounds
        0x41: 메모리 과다 할당
        등...

(3) catch (bytes memory lowLevelData)
    - 로우 레벨 오류(하위 EVM 에러)를 잡을 때 사용
*/

contract math {
    function division(uint256 _num1, uint256 _num2) public pure returns (uint256) {
        require(_num1 < 10, "num1 should not be more than 10");
        return _num1 / _num2;
    }
}

contract runner {
    event CatchErr(string _name, string _err);
    event CatchPanic(string _name, uint256 _errCode);
    event CatchLowLevelErr(string _name, bytes _errData);

    math public mathInstance = new math();

    function playTryCatch(uint256 _num1, uint256 _num2) 
        public 
        returns (uint256, bool) 
    {
        try mathInstance.division(_num1, _num2) returns (uint256 value) {
            return (value, true);

        } catch Error(string memory err) {
            emit CatchErr("require/revert", err);
            return (0, false);

        } catch Panic(uint256 errorCode) {
            emit CatchPanic("assert/Panic", errorCode);
            return (0, false);

        } catch (bytes memory lowLevelData) {
            emit CatchLowLevelErr("LowLevelError", lowLevelData);
            return (0, false);
        }
    }
}

```