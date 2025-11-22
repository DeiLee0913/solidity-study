// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec22 {
    event CountryIndexName(uint256 indexed _index, string _name);
    string[] private countryList = ["South Korea", "USA", "Germany", "Austrailia"];

    /*
        for loop
        - 가장 일반적인 반복문
        - 초기값, 조건식, 증감식을 한 줄에 작성
    */
    function forLoopEvents() public {
        for (uint256 i = 0; i < countryList.length; i++) {
            emit CountryIndexName(i, countryList[i]);
        }
    }

    /*
        while loop
        - 조건이 true인 동안 반복
        - 초기값은 반복문 밖에서 설정
    */
    function whileLoopEvents() public {
        uint256 i = 0;
        while (i < countryList.length) {
            emit CountryIndexName(i, countryList[i]);
            i++;
        }
    }

    /*
        do-while loop
        - 본문을 최소 1번은 실행한다.
        - 그 후 조건을 검사하여 반복 여부 결정
    */
    function doWhileLoopEvents() public {
        uint256 i = 0;
        do {
            emit CountryIndexName(i, countryList[i]);
            i++;
        } while (i < countryList.length);
    }

    /*
        continue
        - 현재 반복을 건너뛰고 다음 반복으로 진행
        - 홀수 index는 건너뛰고 짝수 index만 emit
    */
    function useContinue() public {
        for (uint256 i = 0; i < countryList.length; i++) {
            if (i % 2 == 1) {
                continue; // 오타 수정됨
            }
            emit CountryIndexName(i, countryList[i]);
        }
    }

    /*
        break
        - 조건이 만족되면 반복문을 즉시 종료
        - index가 2가 되면 반복 종료
    */
    function useBreak() public {
        for (uint256 i = 0; i < countryList.length; i++) {
            if (i == 2) {
                break;
            }
            emit CountryIndexName(i, countryList[i]);
        }
    }
}
