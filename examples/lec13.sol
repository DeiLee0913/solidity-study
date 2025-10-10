// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/*
📘 Event
- Solidity에는 print문이 존재하지 않는다.
- 대신 event를 사용해 블록체인 로그에 값을 기록(log)할 수 있다.
- 이벤트는 블록체인에 **불변 데이터(immutable log)** 로 저장되며,
  외부 애플리케이션(예: DApp, Web3.js 등)에서 쉽게 읽을 수 있다.
*/

contract lec13 {
    /*
    ✅ event 정의 형식
    event 이벤트이름(매개변수 타입1 이름1, 매개변수 타입2 이름2, ...);
    */
    event Info(string name, uint256 money);

    /*
    ✅ emit 키워드
    - 이벤트를 발생시켜 블록에 기록(log 저장)
    - 함수 호출 시 콘솔처럼 출력은 안 되지만, 
      트랜잭션 로그를 통해 외부에서 확인 가능
    */
    function sendMoney() public {
        emit Info("KimDaein", 1000);
    }
}
