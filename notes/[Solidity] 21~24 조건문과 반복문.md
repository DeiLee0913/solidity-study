# [Solidity] 21~24: 조건문과 반복문

## 조건문

Solidity의 조건문은 다른 언어들과 크게 다를 바 없음

if, if-else, if-else if-els의 기본적인 구조를 그대로 사용 가능

```python
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
case 1: if-else 
case 2: if-else if-else
*/

contract lec21 {
    string private outcome = "";
    function isIt5(uint256 _number) public returns (string memory) {
        if(_number == 5) {
            outcome = "Yes it is 5.";
            return outcome;
        }
        else if(_number == 3) {
            outcome = "Yes, it is 3.";
            return outcome;
        } else {
            outcome = "No, it is neither 5 nor 3.";
            return outcome;
        }
    }
}
```

## 반복문

### for, while, do-while

- Solidity의 반복문 역시 일반적인 언어와 동일하게 동작

### 반복문 사용 시 주의점

- 반복 횟수만큼 가스가 증가
- 외부 입력에 따라 반복 횟수가 결정되면 **DoS 위험(가스 폭탄)**
- 큰 배열을 on-chain에서 전부 순회하는 것은 지양

```solidity
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

```

### continue, break

- continue
    - 현재 반복을 건너뛰고 다음 반복으로 이동
    - 조건에 따라 특정 케이스만 제외하고 싶은 경우 사용
- break
    - 조건을 만족하면 반복문을 즉시 종료
    - 특정 index에서 더 이상 순회할 필요 없을 때 사용
- emit (이벤트 호출)
    - 블록체인 로그에 기록을 남기는 키워드
    - off-chain에서 데이터 조회 시 매우 유용
    - Solidity 0.4.21 이후 이벤트 호출 시 `emit` 필수

```jsx
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
```

## **Linear String Search (문자열 선형 탐색)**

### 선형 탐색(linear search)

- 배열을 앞에서부터 하나씩 비교하는 O(n) 알고리즘
- Solidity에서는 배열 크기가 작을 때만 체인 사용하는 것이 안전

### Solidity에서의 문자열 비교 방법

Solidity에서는 string끼리의 == 비교 불가능 ← string은 동적 길이 배열(dynamic bytes)이라 내부 데이터 구조가 복잡함

- Solidity는 기본 타입이 아닌 복합 타입끼리 직접 비교를 지원하지 않음

### 문자열 비교 표준 방식

1. 문자열을 bytes로 변환
2. keccak256 해시 적용
3. 해시값 비교

```solidity
keccak256(bytes(str1)) == keccak256(bytes(str2))
```

### keccak256

- EVM 기본 해시 함수이자 가장 빠르고 비용 효율적
- 문자열 직접 비교보다 가스 비용도 절약, 비교는 O(1)의 시간복잡도를 가짐

```python
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
    선형 탐색(Linear Search) + 문자열 비교 방식

    - Solidity에서는 string 타입끼리 직접 == 비교가 불가능
      (저수준에서 string은 동적 바이트 배열이기 때문)

    - 해결 방법:
        문자열 → bytes 변환 → keccak256 해시 적용 → 해시값으로 비교

    - keccak256(bytes(string)):
        EVM에서 가장 많이 사용하는 해시 함수
    
    - 선형 탐색(linear search):
        배열을 앞에서부터 하나씩 비교하며 원하는 값을 찾는 방식.
        배열 크기가 작을 때 사용하기 적합.
*/

contract lec24 {
    event CountryIndexName(uint256 indexed _index, string _name);
    string[] private countryList = ["South Korea", "North Korea", "USA", "China", "Japan"];

    function linearSearch(string memory _search) public view returns(uint256, string memory) {
        for(uint256 i = 0; i < countryList.length; i++) {
            // Solidity는 string == string 비교 불가 → bytes 변환 후 keccak256 해시 비교
            if(keccak256(bytes(countryList[i])) == keccak256(bytes(_search))) {
                return (i, countryList[i]);
            }
        }
        return (0, "Nothing");
    }
}
```