# Solidity [17~20] Mapping & Array & Struct

# Mapping

- `mapping`은 **key-value 쌍**으로 데이터를 저장하는 자료형
- `key`를 이용해 `value`를 바로 접근할 수 있으며, `key`는 중복될 수 없고 각 key는 하나의 value만 가짐
- 존재하지 않는 key를 조회하면 **기본값(default value)**이 반환
- **배열처럼 순서(index)** 나 **길이(length)** 를 알 수 없음
- `mapping`은 반복(iteration)이 불가능
- 주로 **데이터베이스처럼 특정 값을 빠르게 조회할 때** 사용

### 문법 구조

```solidity
mapping([key 자료형] => [value 자료형]) [가시성] [이름];
```

```solidity
mapping(uint256 => string) public studentNames;
mapping(address => uint256) private balances;
```

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/* Mapping
- mapping은 key-value 쌍으로 데이터를 저장하는 자료구조.
- key를 통해 value에 직접 접근하는 방식.
- 배열과 달리 '순서'나 '길이(length)'를 알 수 없음.
- key는 중복될 수 없으며, 존재하지 않는 key를 조회하면 기본값(default value)을 반환함.
*/

// mapping은 키와 value로 구성되어 있기 때문에 Length를 알 수 없음
contract lec17 {
    /* mapping 정의 형식
    mapping([key 자료형] => [value 자료형]) [가시성] [이름];
    */

    mapping(uint256 => uint256) private ageList;
    mapping(string => uint256) private priceList;
    mapping(uint256 => string) private nameList;

    // ageList: uint256 -> uint256
    function setAgeList(uint256 _index, uint256 _age) public {
        ageList[_index] = _age;
    }

    function getAge(uint256 _index) public view returns(uint256) {
        return ageList[_index];
    }

    // nameList: unint256 -> string
    function setNameList(uint256 _index, string memory _name) public {
        nameList[_index] = _name;
    }

    function getNameList(uint256 _index) public view returns(uint256) {
        return ageList[_index];
    }

    function setPriceList(string memory _itemName, uint256 _price) public {
        priceList[_itemName] = _price;
    }

    function getPriceList(string memory _index) public view returns(uint256) {
        return priceList[_index];
    }
}
```

## Mapping의 getter와 setter

### **set/get은 함수가 아니라 연산자 동작이다**

- Solidity의 `mapping`은 JavaScript나 Python의 딕셔너리처럼 값을 직접 넣고 꺼내는 **특수 문법(special syntax)** 으로 다뤄짐
- 즉, 아래의 두 줄은 함수 호출이 아니라 단순한 **대입 연산으로, 내장 함수가 아닌 언어 차원의 문법으로 처리됨**
- 직접 작성한 `getPrice()`나 `_setPrice()` 함수는 `mapping`의 기능을 확장하거나 보호하기 위한 **wrapper 함수**일 뿐이며, `mapping` 자체의 내장 함수는 아님

### `public` `mapping`의 getter는 기본 제공된다

- `mapping`이나 `state variable`을 `public`으로 선언하면 자동으로 **getter 함수**가 생성
    
    ```solidity
    mapping(address => uint256) public balance;
    ```
    
- 위 코드만으로도 별도의 `getBalance()` 함수를 작성할 필요 없이 `balance(address)` 형태로 값을 조회 가능
- 이는 아까 말했듯이  내장 함수(built-in function)가 아니라, **컴파일러가 자동으로 만들어주는 “syntactic sugar”**(문법적 편의 기능)
    
    위 mapping 정의를 Solidity 컴파일러가 내부적으로 해석하면 다음과 같이 바뀌어 컴파일러가 자동으로 **같은 이름의 getter 함수**를 생성해줌
    
    ```solidity
    mapping(address => uint256) private balance_storage;
    
    function balance(address _key) public view returns (uint256) {
        return balance_storage[_key];
    }
    ```
    

### 내장 함수? 편의 기능?

| 구분 | 예시 | 누가 만들었나 | 코드 위치 | 생성 시점 | 의미 |
| --- | --- | --- | --- | --- | --- |
| **Solidity public getter** | `mapping(uint => uint) public data;` | Solidity 컴파일러 | 코드에는 없음 (자동 생성) | 컴파일 시 | 문법적 편의 기능 (syntactic sugar) |
| **Java getter/setter (IDE)** | `getName(), setName()` | 개발 도구 (예: IntelliJ) | 코드에 직접 생성 | 작성 시 | 코드 자동 완성 기능 |
| **Python dataclass getter** | `@dataclass` | Python 인터프리터 | 코드에는 없음 | 런타임 시 | 자동 메서드 추가 |
| **C++ STL vector.push_back()** | `v.push_back(10);` | STL 구현자(라이브러리 코드) | 표준 라이브러리 내부 | 컴파일 시 링크됨 | 실제 멤버 함수 호출 |

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/* mapping의 기본적인 접근 제한 구조 예시

- mapping은 보통 'private'으로 선언하고,
  외부에서는 getter 함수를 통해 읽기만 가능하게 한다.
- setter는 public 대신 internal로 두어
  다른 내부 함수만 수정할 수 있도록 제한할 수 있다.
*/

contract Mapping {
    // key: string (상품 이름)
    // value: uint256 (가격)
    mapping(string => uint256) private priceList;

    // Getter: 외부 접근 가능, 누구나 가격을 조회할 수 있음 (읽기 전용)
    function getPrice(string memory _item) public view returns (uint256) {
        return priceList[_item];
    }

    // Setter: internal 키워드로, 컨트랙트 내부에서만 호출 가능하게 함
    function _setPrice(string memory _item, uint256 _price) internal {
        priceList[_item] = _price;
    }

    // public 함수가 내부 setter를 호출하여 mapping 값 수정
    function updateSampleData() public {
        _setPrice("apple", 1000);
        _setPrice("banana", 1500);
    }
}
```

# Array

```sql
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/* 배열(Array)

- mapping과 달리 배열은 length를 확인할 수 있음.
- 배열을 순환(iteration)하며 조작하는 기능은 DDoS 공격에 취약하므로,
  Solidity에서는 array보다 mapping을 더 선호.
- 배열은 가능한 한 크기에 제한을 두고 사용하는 것이 좋음.
*/

contract lec18 {
    // 동적 배열(길이가 유동적으로 변함)
    uint256[] public ageArray;
    // 고정 크기 배열(길이가 10으로 고정됨)
    uint256[10] public ageFixedSizeArray;
    // 묹열 배열 선언과 동시에 초기화
    string[] public nameAray = ["Kal", "Jhon", "Kerri"];

    // 배열의 길이를 반환하는 함수
    function AgeLength() public view returns(uint256) {
        return ageArray.length;
    }

    // 배열의 끝에 새로운 값을 추가하는 함수
    // 인덱스는 0부터 시작
    function AgePush(uint256 _age) public {
        ageArray.push(_age);
    }

    // 특정 인덱스의 값을 반환하는 함수
    // 인덱스가 배열 범위를 벗어나면 오류 발생
    function AgeGet(uint256 _index) public view returns(uint256) {
        return ageArray[_index];
    }

    // 배열의 마지막 요소를 제거
    // 가장 마지막 인덱스의 값을 삭제하고 배열의 길이를 1 줄임
    function AgePop() public {
        ageArray.pop();
    }

    // 특정 인덱스의 값을 기본값(0)으로 초기화하는 함수
    // 따라서 배열의 길이는 줄어들지 않음    function AgeDelete(uint256 _index) public {
    function AgeDelete(uint256 _index) public {
        delete ageArray[_index];
    }

    // 특정 인덱스의 값을 다른 값으로 변경하는 함수
    // 인덱스가 범위를 벗어나면 오류 발생
    function AgeChange(uint256 _index, uint256 _age) public {
        ageArray[_index] = _age;
    }
    
}
```

# Mapping과 Array의 값 **수정 (Update)**

## Solidity의 업데이트 개념 이해하기

### 일반 언어(C, Python, Java)의 “값 변경”

일반 언어에서는 변수나 배열이 **메모리 상의 임시 데이터** 즉, `int a = 10;` `a = 20;`

이렇게 하면 단순히 메모리 상의 값이 교체될 뿐, 그 흔적은 남지 않고 프로그램 종료 시 사라짐

⇒ “값 변경(change)”으로 메모리나 스택 상의 단순한 값 교체를 의미

### Solidity에서는 “업데이트(update)”

Solidity에서 `mapping`, `array`, `storage 변수` 등은 모두 **블록체인 스토리지(storage)** 에 저장되어 “하드디스크처럼 영구 저장되는 데이터 공간”에 영구 저장

`numMap[0] = num;`

이 한 줄은 단순한 변수 교체가 아니라, 블록체인의 상태(state)를 수정하는 작업 즉, 새로운 상태를 기록하는 트랜잭션을 의미함

`mapping`이나 `array`에 데이터를 대입하는 순간, 그 내용이 **EVM의 storage 슬롯**(영구 저장 공간)에 다시 기록되고, 이게 블록체인에 반영

⇒ “업데이트(update)”는 **저장소(storage)에 기록된 상태값을 수정하는 행위**를 의미

---

```sql
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
Solidity에서 mapping과 array는 '값 변경'이 아니라 '업데이트' 개념으로 동작한다.
즉, 새로운 변수에 같은 이름으로 다시 할당하는 것이 아니라,
기존에 선언된 자료구조의 특정 인덱스나 키를 직접 수정해야 값이 반영된다.

예를 들어:
- mapping: numMap[key] = newValue;
- array:   numArray[index] = newValue;

만약 mapping이나 array 자체를 새로 선언하거나 재할당하려고 하면,
컴파일 에러가 발생하거나 기존 데이터가 유지되지 않는다.
*/

contract lec19 {
    mapping(uint256 => uint256) public numMap;
    uint256[] public newArray;
    uint256 public num = 100;

    // mapping의 특정값 업데이트
    function numMappAdd() public {
        numMap[0] = num;    // 기존 key(0)d에 새로운 값 저장
    }

    // 배열의 특정 인덱스 값 업데이트
    function updateArray() public {
        // 배열에 값이 없는 상태에서 인덱스 접근 시 오류가 발생하므로
        // 먼저 요소를 추가(push)한 뒤 값을 갱신하는 것이 안전
        if (newArray.length == 0) {
            newArray.push(num);
        } else {
            newArray[0] = num;  // 인덱스의 0의 값 수정
        }

        newArray[0] = num;
    }
}
```

# Struct

- **구조체(struct)** 는 서로 다른 자료형의 변수들을 하나로 묶어 관리할 수 있는 **사용자 정의 자료형**
- 구조체를 사용하면 관련 있는 데이터를 하나의 단위로 다루기 때문에 코드의 가독성과 유지보수성이 높아짐

> 구조체는 데이터베이스의 레코드(Record) 와 비슷한 개념으로 이해할 수 있음
> 

## 문법 구조

### 구조체의 정의

나이(`uint`), 이름(`string`), 직업(`string`) 등 여러 속성을 하나의 **Character 구조체**로 정의

```solidity
struct Character {
		uint256 age;
		string name;
		string job;
	}
```

### 구조체의 인스턴스 생성(makeCharacter)

입력값을 받아 새로운 Character 구조체를 만들어 반환

```solidity
function makeCharacter(
    uint256 _age,
    string memory _name,
    string memory _job
) public pure returns (Character memory) {
    return Character(_age, _name, _job);
}
```

- 저장하지 않고 반환만 하기 때문에 pure 함수로 선언되어 있음
- 즉, 이 함수는 단순히 구조체를 생성해서 메모리(memory) 상에서만 보여주는 역할

### Mapping으로 구조체 저장 및 조회하기

```solidity
mapping(uint256 => Character) public CharacterMapping;

function createCharacterMapping(
    uint256 _key,
    uint256 _age,
    string memory _name,
    string memory _job
) public {
    CharacterMapping[_key] = Character(_age, _name, _job);
}
```

전달받은 key에 해당 구조체를 저장

- 각 key에 대응하는 Character를 빠르게 조회할 수 있음
- 동일한 key를 다시 저장하면 **기존 값이 덮어쓰기(업데이트)** 됨

```solidity
function getCharacterMapping(uint256 _key)
    public
    view
    returns (Character memory)
{
    return CharacterMapping[_key];
}
```

특정 key에 저장된 구조체를 반환

### Array로 구조체 저장 및 조회하기

```solidity
Character[] public CharacterArray;

function createCharacterArray(
    uint256 _age,
    string memory _name,
    string memory _job
) public {
    CharacterArray.push(Character(_age, _name, _job));
}
```

배열에 구조체를 순서대로 저장

- **인덱스(index)** 가 자동으로 부여되므로, 데이터의 순서를 관리 가능
- `push()`는 배열의 마지막에 데이터를 추가하는 **내장 함수**

```solidity
function getCharacterArray(uint256 _index)
    public
    view
    returns (Character memory)
{
    return CharacterArray[_index];
}
```

- 배열 내 특정 인덱스의 구조체를 조회

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
Struct (구조체)

- 구조체(struct)는 여러 개의 변수를 하나의 그룹으로 묶어 관리할 수 있는 사용자 정의 자료형이다.
- 다양한 타입의 데이터를 하나의 단위로 다룰 수 있기 때문에,
  캐릭터 정보, 사용자 프로필, 상품 정보 등 복합 데이터를 표현할 때 자주 사용된다.
  */

contract lec20 {
    // 구조체 Character 정의
    struct Character {
        uint256 age;
        string name;
        string job;
    }

    // 구조체 인스턴스를 생성해서 반환하는 함수(저장하지는 않음)
    // 'pure' 함수이므로 블록체인 상태를 변경하지 않음
    function makeCharacter(
        uint256 _age,
        string memory _name,
        string memory _job
    ) public pure returns (Character memory) {
        return Character(_age, _name, _job);
    }

    // 1. mapping을 이용한 구조체 저장
    mapping(uint256 => Character) public CharacterMapping;
    
    // 2. array를 이용한 구조체 저장
    Character[] public CharacterArray;

    // 구조체(Character)를 mapping에 추가
    function createCharacterMapping(uint256 _key, uint256 _age, string memory _name, string memory _job) public {
        CharacterMapping[_key] = Character(_age, _name, _job);
    }

    // 구조체(Character) mapping에서 조회
    function getCharacterMapping(uint256 _key) public view returns(Character memory) {
        return CharacterMapping[_key];
    }

    //구조체(Character)를 배열에 추가
    function createCharacterArray(uint256 _age, string memory _name, string memory _job) public {
        CharacterArray.push(Character(_age, _name, _job));
    }

    // 구조체(Character)를 배열에서 조회
    function getCharacterArray(uint256 _index) public view returns(Character memory) {
        return CharacterArray[_index];
    }
}

```