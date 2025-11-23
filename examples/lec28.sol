// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
try/catch 사용 위치

1. 외부 스마트 컨트랙트 함수 호출
   - 다른 컨트랙트를 인스턴스화하고 그 함수를 호출할 때 사용 가능

2. 외부 스마트 컨트랙트 생성(new Contract)
   - 생성자 실행 중 발생하는 revert를 잡을 수 있음

3. 같은 컨트랙트 내부 함수 호출
   - 단, this를 사용해 external 호출 형태로 호출해야 함
   - 내부 함수 직접 호출(simple())은 try/catch 불가
*/

// 1. 외부 스마트 컨트랙트 생성(new Contract)
contract Character {
    string private name;
    uint256 private power;

    constructor(string memory _name, uint256 _power) {
        // revert("error");   // 고의 에러 테스트용
        name = _name;
        power = _power;
    }
}

contract Runner {
    event CatchOnly(string _name, string _err);

    function playTryCatch(string memory _name, uint256 _power)
        public
        returns (bool successOrFail)
    {
        try new Character(_name, _power) {
            // revert("error in try-block");  // try 내부 에러는 catch로 잡히지 않음
            return true;

        } catch {
            emit CatchOnly("catch", "Errors!!");
            return false;
        }
    }
}

// 2) 같은 컨트랙트 내부에서 this를 통해 함수를 호출하는 경우
contract Runner2 {

    function simple() external pure returns (uint256) {
        return 4;
    }

    event CatchOnly(string _name, string _err);

    function playTryCatch()
        public
        returns (uint256, bool)
    {
        try this.simple() returns (uint256 value) {
            return (value, true);

        } catch {
            emit CatchOnly("catch", "Errors!!");
            return (0, false);
        }
    }
}