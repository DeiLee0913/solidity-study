// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
    continue: 현재 반복을 건너뛰고 다음 반복으로 즉시 이동한다.
    break: 반복문을 즉시 종료한다.

    emit: 이벤트(Event)를 블록체인에 기록(로그 저장)하는 명령어
    → 트랜잭션 로그에 정보를 남기며, off-chain에서 데이터를 추적할 때 자주 사용됨
    → 이벤트를 호출할 때 반드시 emit 키워드를 붙여야 함 (Solidity 0.4.21 이후)

*/
contract lec23 {
    event CountryIndexName(uint256 indexed _index, string _name);
    string[] private countryList = ["South Korea", "North Korea", "USA", "China", "Japan"];

    // continue 예시: 홀수 index는 건너뛰고 짝수 index만 이벤트 발생
    function useContinue() public {
        for (uint256 i = 0; i < countryList.length; i++) {
            if (i % 2 == 1) {
                continue;
            }
            emit CountryIndexName(i, countryList[i]);
        }
    }

    // break 예시: index가 2가 되면 반복문 즉시 종료
    function useBreak() public {
        for(uint256 i = 0; i < countryList.length; i++) {
            if(i == 2) {
                break;
            }
            emit CountryIndexName(i, countryList[i]);
        }
    }
}