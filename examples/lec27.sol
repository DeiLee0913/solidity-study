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
