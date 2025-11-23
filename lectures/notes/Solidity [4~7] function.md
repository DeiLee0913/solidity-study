# Solidity [4~7]: function

# Solidity [4]: function 정의

```solidity
function [이름] ([매개변수]) [접근제어자] returns ([반환할 타입]) {
	...
}
```

- 함수 호출 시마다 Gas 소비
- 각 함수별로 Gas 소비량 예측치 확인 가능
- return이 아닌 returns 사용

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec4 {
    /*
    function [이름] ([매개변수]) [접근제어자] returns ([반환할 타입]) {
        [함수 본문]
    }
    */

    uint256 public a = 3;

    // 1. 매개변수와 반환값이 없는 함수: 상태 변수 a를 5로 고정 변경
    function setAtoFive() public {
        a = 5;
    }

    // 2. 매개변수는 있고 반환값이 없는 함수: 입력받은 값으로 a를 변경
    function setA(uint256 _value) public {
        a = _value;
    } 

    // 3. 매개변수와 반환값이 모두 있는 함수: 입력받은 값으로 a를 변경하고 변경된 값 반환
    function setAAndReturn(uint256 _value) public returns (uint256) {
        a = _value;
        return a;
    }
}
```

# solidity [5]: 가시성 접근 제어자

- 접근 제어자: 함수나 상태 변수에 대한 **가시성(visibility)** 과 **접근 권한(access control)** 을 지정하는 키워드
- **가시성(Visibility)**: 어디서 접근할 수 있는지 범위를 정의
- **접근 권한(Access Control)**: 누가 실행할 수 있는지 권한을 제한

## **가시성(Visibility) 제어자**

### **public**

- 누구나 접근 가능 (외부, 내부, 상속 컨트랙트 모두 가능)
- 상태 변수에 `public`을 붙이면 자동으로 `getter` 함수가 생성됨

### **private**

- 선언된 컨트랙트 내부에서만 접근 가능
- 상속받은 컨트랙트에서도 접근 불가.

### **internal**

- 선언된 컨트랙트와 이를 상속받은 컨트랙트에서 접근 가능
- 외부에서는 접근 불가

### **external**

- 컨트랙트 **외부에서만** 호출 가능 (다른 컨트랙트나 트랜잭션을 통해)
- 내부에서 호출하려면 `this.functionName()` 같은 방식으로 가능하지만, 가스비가 추가로 소모됨
- 함수 전용 가시성 제어자로, 상태 변수(external)에 접근 제어자를 붙일 수 없음
- 보통 외부 API 성격의 함수에 사용

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec5 {
    // public 변수: 어디서나 접근 가능, 자동 getter 생성됨
    uint256 public a = 5;
    // private 변수: 같은 컨트랙트 내부에서만 접근 가능
    uint256 private b = 5;

    // private 변수 접근을 위한 public 함수
    function getPrivate() public view returns (uint256) {
        return b;
    }
}

contract Original {
    uint public pu = 3;      // public: 어디서나 접근 가능
    uint private pr = 2;     // private: 같은 컨트랙트 내부에서만 접근 가능
    uint internal i = 1;     // internal: 같은 컨트랙트 + 상속 컨트랙트에서 접근 가능
    // uint external e = 5;  // ❌ external은 변수에 사용 불가

    // external 함수: 외부에서만 호출 가능
    function setExternal(uint _v) external {
        pu = _v;
    }

    // public 함수: 어디서나 호출 가능
    function changePublic(uint256 _value) public {
        pu = _value;
    }

    // private 함수: 같은 컨트랙트 내부에서만 호출 가능
    function changePrivate(uint256 _value) public {
        pr = _value;
    }

    // internal 함수: 같은 컨트랙트 + 상속 컨트랙트에서 호출 가능
    function changeInternal(uint256 _value) public {
        i = _value;
    }

    // public getter (자동 생성 getter와 동일 기능)
    function get_pu() view public returns (uint256) {
        return pu;
    }

    // private 접근 확인: 내부에서 private 함수 호출 가능
    function testPrivate(uint _v) public {
        changePrivate(_v);  // 가능
    } 

    // internal 접근 확인: 내부에서 internal 함수 호출 가능
    function testInternal(uint _v) public {
        changeInternal(_v); // 가능
    } 
}

// Original을 상속받은 컨트랙트: internal 함수 접근 가능
contract Inherited is Original {
    // intenal 접근 확인: 상속 받은 contract에서 internal 함수 접근 가능
    function useInternal(uint _v) public {
        changeInternal(_v); 
    }
}

// 외부 컨트랙트에서 Original 인스턴스 생성 후 접근
contract External_contract {
    Original instance = new Original();

    function changeByPublic(uint _v) public {
        instance.changePublic(_v);      // public 함수 접근 가능
    }

    function changeByExternal(uint256 _v)  public {
        instance.setExternal(_v);       // external 함수 접근 가능
    }

    function use_public_example() public view returns (uint256) {
        return instance.get_pu();
    }
}
```

# Solidity [6]: view와 pure

| 함수 유형 | 상태 변수 읽기 | 상태 변수 변경 | Gas 소비 | 설명 |
| --- | --- | --- | --- | --- |
| **view** | 가능 | 불가능 | 없음 (읽기 전용) | 읽기 전용 함수 |
| **pure** | 불가능 | 불가능 | 없음 (계산 전용) | 외부 입력값/내부 변수만 사용 |
| **(기본)** | 가능 | 가능 | 있음 | 상태 변경 트랜잭션 발생 |

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec6 {
    /*
    view: 상태 변수(state variable)들을 읽을 수 있으나 변경 불가능
    pure:   상태 변수를 읽거나 변경할 수 없음 (함수 내부 연산만 가능)
    (view, pure 모두 미사용 시): 상태 변수를 읽고 변경할 수 있음 → 트랜잭션 발생
    */

    uint256 public a = 1;

    // 1. view 함수: 상태 변수를 읽을 수 있으나, 변경 불가능
    function read_view() public view returns (uint256) {
        return a + 2;
    }

    // 2. pure 함수: 상태 변수를 읽거나 변경할 수 없음
    function read_pure() public pure returns (uint256) {
        uint256 b = 1;
        return 4 + 2 + b;
    }

    // 3. 기본 함수: 상태 변수를 읽고 변경 가능 (트랜잭션 발생)
    function read() public returns (uint256) {
        a = 13;
        return a;
    }
}
```

# Solidity [7]: 4개의 저장영역과 string

## 데이터 저장 영역(Data Location)

### **1. storage**

- 대부분의 **상태 변수(state variable)**, 구조체, 매핑 등이 저장되는 **영속적 저장소**
- 블록체인에 직접 기록되므로 **가스 비용이 가장 비쌈**
- 함수가 끝나도 데이터가 유지됨
- 컨트랙트의 상태를 나타내는 변수들이 여기에 저장됨

```solidity
uint256 public value = 10; // storage에 저장됨
```

### **2. memory**

- 함수 실행 중에만 존재하는 **임시 저장소**
- 주로 **함수의 매개변수, 반환값, 지역 변수(참조 타입)** 이 여기에 저장됨
- 함수가 끝나면 자동으로 사라짐
- storage보다 **가스 비용이 저렴**
- 단, 데이터 복사가 일어나므로 calldata보다 비쌈

```solidity
function setName(string memory _name) public pure returns (string memory) {
    return _name;
```

### **3. calldata**

- **external 함수의 매개변수**에서 사용되는 **읽기 전용 메모리 영역**
- 데이터가 복사되지 않고 그대로 전달되므로, **가장 가스 효율적**
- 함수 내부에서 값을 변경할 수 없음 (read-only)
- 대용량 데이터(문자열, 배열)를 외부에서 받을 때 유용

```solidity
function showName(string calldata _name) external pure returns (string calldata) {
    return _name; // 읽기만 가능, 변경 불가
}
```

### **4. stack**

- EVM(Ethereum Virtual Machine) 내부에서 연산 시 사용하는 **임시 저장 영역**
- 모든 연산이 스택 기반으로 수행됨
- 최대 **1024 slot (32바이트 단위)** 제한
- 값(value) 타입 변수는 기본적으로 스택에 저장됨
- 접근 속도는 가장 빠르고, 가스 비용도 저렴

```solidity
function add(uint256 x, uint256 y) public pure returns (uint256) {
    return x + y; // 연산 중 스택에 임시 저장
}
```

| 구분 | 지속성 | 수정 가능 | 주 사용 위치 | 가스 비용 | 비고 |
| --- | --- | --- | --- | --- | --- |
| **storage** | 영속적 | 가능 | 상태 변수 | 💰💰💰  | 블록체인 저장 |
| **memory** | 임시 | 가능 | 함수 내 지역 변수 | 💰 | 함수 실행 중 유효 |
| **calldata** | 임시 | ❌ (읽기 전용) | external 함수 매개변수 | 💰 | 복사 없이 전달 |
| **stack** | 임시 | 가능 | EVM 내부 연산 | 💰 | 최대 1024 slot 제한 |

## solidity의 문자열(string) 타입

- Solidity의 `string`은 **동적 크기의 UTF-8 인코딩 문자열**
- 내부적으로 **바이트 배열(bytes)** 로 관리되며, **reference(참조) 타입**
    
    
    | 타입 종류 | 예시 | 저장 방식 | 비유 |
    | --- | --- | --- | --- |
    | 값(Value) 타입 | `uint`, `bool`, `address` | 값 자체를 스택에 저장 | 종이에 숫자를 직접 적는 것 |
    | 참조(Reference) 타입 | `string`, `array`, `struct`, `mapping` | 값이 저장된 장소를 가리킴 | 파일 경로를 메모해두는 것 |
- 따라서 함수 매개변수나 반환값으로 사용할 때는 **데이터 저장 위치(data location)**를 명시 (e.g. `string memory`, `string calldata`)
- Solidity는 문자열 길이나 인덱스 접근 같은 기능이 제한적이므로, 문자열 조작 시 **bytes 변환**이 자주 사용됨

### string의 저장 위치

| 키워드 | 사용 위치 | 수정 가능 | 설명 |
| --- | --- | --- | --- |
| `storage` | 상태 변수 | ✅ 가능 | 블록체인에 영구 저장됨 |
| `memory` | 함수 내 지역 변수 / 매개변수 | ✅ 가능 | 임시 저장소, 함수 실행 중 유효 |
| `calldata` | `external` 함수 매개변수 | ❌ 불가능 | 읽기 전용, 가장 가스 효율적 |

### string example

- 문자열의 **바이트 수** 반환 `string.length` ❌ / `bytes(string).length` ✅
- n번째 **바이트에 접근** `string[index]` ❌ / `bytes(string)[index]` ✅

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract StringExample {
    // 1. storage: 상태 변수
    string public greeting = "Hello Solidity"; // 영구 저장

    // 2. memory: 함수 내에서 문자열 처리 (임시)
    function setGreeting(string memory _text) public pure returns (string memory) {
        // 메모리 상에서 문자열을 합쳐 반환
        return string(abi.encodePacked("Hi, ", _text));
    }

    // 3. calldata: external 함수의 읽기 전용 매개변수
    function echo(string calldata _input) external pure returns (string calldata) {
        return _input; // 읽기만 가능, 수정 불가
    }
}
```

## stringToBytes

Solidity에서는 `string`의 길이나 특정 인덱스 접근이 불가능하므로, **bytes 타입으로 변환**하여 처리한다.

```solidity
function getFirstLetter(string memory _word) public pure returns (bytes1) {
    bytes memory byteWord = bytes(_word); // string → bytes 변환
    return byteWord[0]; // 첫 글자 반환
}

function getLength(string memory _word) public pure returns (uint256) {
    return bytes(_word).length; // 문자열 길이 반환
}
```

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec7 {
    /*
 1. storage
       - 대부분의 상태 변수와 구조체, 매핑 등이 저장되는 영속적 저장소
       - 블록체인에 직접 기록되므로 가스 비용이 가장 비쌈
       - 함수 호출이 끝나도 값이 유지됨 (state variable 저장)

    2. memory
       - 함수의 매개변수, 반환값, 지역 변수(참조 타입) 등이 저장됨
       - 함수 실행 동안에만 존재하는 임시 메모리 영역
       - storage보다 가스 비용이 저렴 (영속 저장이 아니므로)

    3. calldata
       - external 함수의 매개변수에 사용되는 읽기 전용 데이터 영역
       - 메모리 복사가 일어나지 않아, gas 효율성이 가장 높음
       - 수정 불가(read-only)

    4. stack
       - EVM(Ethereum Virtual Machine)이 연산 시 사용하는 임시 저장 영역
       - 최대 1024개의 slot (32바이트씩)으로 제한
    */
    

    // string은 기본 타입이 아니라 동적 배열로 관리 → 참조(reference) 타입
    function get_string(string memory _str) public pure returns(string memory) {
        return _str;
    }

    // 기본 타입(uint)은 값(value) 타입으로, 별도 메모리 지정 필요 없음
    function get_uint(uint256 _ui) public pure returns(uint256) {
        return _ui;
    }
}
```