# Solidity [8~16]: instance & inheritance

# Solidity [8]: instance

*Solidity에서 **한 컨트랙트가 다른 컨트랙트를 내부에서 사용하기 위해 생성하는 객체***

즉, 컨트랙트 A의 코드를 컨트랙트 B 안에서 직접 사용하려면 B 내부에서 A의 **인스턴스(복제본)** 을 만들어야 함

### 생성 방법

```solidity
A aInstance = new A();
```

- `new` 키워드를 사용해 **A 컨트랙트의 인스턴스(새로운 A 컨트랙트)**를 생성
- 이렇게 생성된 인스턴스는 **독립된 저장공간과 상태를 가진 별도의 컨트랙트**가 됨

### 인스턴스 사용 이유

1. **다른 컨트랙트의 함수나 변수를 사용하기 위해**
    - 한 컨트랙트 내부에서는 자신이 아닌 다른 컨트랙트의 데이터나 로직에 직접 접근할 수 없음
    - 따라서 인스턴스를 만들어야 그 컨트랙트의 함수를 호출하거나 변수를 읽을 수 있음
2. **컨트랙트 간 상호작용 구현**
    - 여러 컨트랙트가 협력해야 하는 상황(예: 토큰 전송, DApp 구조 설계 등)에서
        
        인스턴스를 통해 함수 호출 및 상태 변경이 가능
        

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
instance를 사용하는 이유:
한 컨트랙트(예: B)에서 다른 컨트랙트(예: A)의 함수나 변수를 사용하기 위해
해당 컨트랙트의 '인스턴스(복제된 객체)'를 생성해야 함

즉, B 컨트랙트 안에서 A 컨트랙트의 기능을 직접 호출하려면,
먼저 A의 인스턴스를 만들어야 함
*/

contract A {
    uint256 public a = 5;

    function change(uint256 _value) public {
        a = _value;
    }
}

contract B {
    // A 컨트랙트의 인스턴스 생성
    A aInstance = new A();

    // A 컨트랙트의 상태 변수 value를 읽어오기 (읽기 전용이므로 view)
    function getValueFromA() public view returns(uint256) {
        return aInstance.a();
    }

    function updateValueInA(uint256 _value) public {
        aInstance.change(_value);
    }
}
```

# Solidity [9]: instance constructor

## 생성자(Constructor)

- 컨트랙트가 **배포될 때 단 한 번만 실행되는 특별한 함수**
- 주로 상태 변수의 **초기값을 설정**하는 데 사용
- 함수명은 `constructor`로 고정되어 있으며, **반환값이 없음**
- 생성자는 한 컨트랙트당 하나만 존재할 수 있음

### 가스 비용 관련 주의점

- `new A(...)` 로 인스턴스를 생성할 때마다 **A 컨트랙트가 새로 배포되므로 가스가 많이 소비됨**
- 블록당 가스 한도(Block Gas Limit)를 초과하면 트랜잭션이 **실패하거나 네트워크에서 거부**됨
- 이런 문제를 줄이기 위해 사용하는 기법 중 하나가 **Clone Factory Pattern (Minimal Proxy Pattern)**
    
    → 이미 배포된 컨트랙트를 복제(clone) 형태로 재활용하여 새로운 배포 없이 동일한 로직을 사용하는 방식
    

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/* 생성자(Constructor)
- 컨트랙트가 배포될 때 단 한 번만 실행되는 특별한 함수
- 주로 상태 변수의 '초기값 설정'에 사용 */

contract A {
    string public name;
    uint256 public age;

    // 생성자: 컨트랙트가 배포될 때 자동으로 실행됨
    constructor(string memory _name, uint256 _age) {
        name = _name;
        age = _age;
    }

    // 상태 변수 변경 함수
    function change(string memory _name, uint256 _age) public {
        name = _name;
        age = _age;
    }
}

/* 다른 컨트랙트에서 생성자 사용하기
- new 키워드로 Person 컨트랙트의 인스턴스를 생성할 때, 생성자의 매개변수(_name, _age)를 함께 전달해야 함
- 인스턴스 생성 시마다 새로운 컨트랙트가 블록체인에 배포되므로 가스 소비가 많을 수 있음
- 블록마다 제한된 가스량을 초과하면 이더리움 생계에 대한 접근 자체가 차단됨
  (이를 최적화하는 패턴 중 하나가 'Clone Factory Pattern') 
*/
contract B {
    // Person 컨트랙트 인스턴스 생성 (생성자 인자 전달)
    A instance = new A("Alice", 52);

    // Person의 정보 변경 함수
    function change(string memory _name, uint256 _age) public {
        instance.change(_name, _age);
    }

    // Person의 현재 정보 조회 함수
    function get() public view returns(string memory, uint256) {
        return (instance.name(), instance.age());
    }
}
```

- `_name`, `_age` 매개변수를 받아 상태 변수 초기화
- `constructor` 는 외부에서 호출할 수 없으며, 배포 시 자동 실행

# Solidity [10] : inheritance

```solidity
contract Parent {
    // 부모 컨트랙트의 상태 변수 및 함수
}

contract Child is Parent {
    // 부모의 기능을 물려받고, 필요한 기능만 추가로 정의 가능
}
```

## 상속(Inheritance)

한 컨트랙트가 다른 컨트랙트의 변수와 함수를 **물려받는 것**

- Solidity에서는 `is` 키워드로 구현

## 부모 생성자 호출

- 부모 컨트랙트에 생성자가 존재하면, 자식 컨트랙트는 **부모 생성자에 필요한 인자값을 전달해야 함**
- 상속 구문에서 직접 전달하거나 자식 생성자 안에서 호출할 수 있음

### 축약형 (Implicit Form)

부모 생성자 호출 인자를 **상속 구문(`is`) 옆에 직접 전달**하는 방식

- 가장 간단하게 부모 생성자를 실행 가능

### 명시형(Explicit Form)

*자식 컨트랙트의 constructor 내부에서 부모 생성자를 **직접 호출**하는 방식*

- 부모 생성자에 인자를 전달하면서 자식 컨트랙트만의 초기화 로직을 함께 정의할 수 있음
- 자식 배포 시 부모 생성자는 자동 호출됨
- 부모 생성자가 인자를 요구할 때 그 인자를 반드시 자식이 넘겨야함

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Father {
    string public familyName = "Kim";
    string public givenName = "Jung";
    uint256 public money = 100;

    constructor(string memory _givenName) {
        givenName = _givenName;
    }

    function getFamilyName() view public returns(string memory)  {
        return familyName;
    }

    function getGivenName() view public returns(string memory)  {
        return givenName;
    }

    function getMoney() view public returns(uint256)  {
        return money;
    }
}

/* 부모 생성자 호출 방식
    1. 축약형(Implicit form)
    - 부모 생성자에 전달할 인자를 상속 구문(is) 옆에 직접 명시
    - 간단히 표현 가능하지만, 자식 컨트랙트에 별도 초기화 코드가 없을 때 주로 사용
*/

// 축약 버전 부모 생성자 호출: 부모 생성자 호출 인자를 상속 구문에 직접 전달
**contract Son is Father("James") {}**

/*
    2. 명시형 (Explicit form)
   - 자식 컨트랙트의 constructor 내부에서 부모 생성자를 직접 호출
   - 부모 생성자 인자와 함께 자식 전용 초기화 코드도 추가 가능
*/

**// contract Son is Father {
//     constructor() Father("James") {
//         //Son 전용 초기화 코드 추가 가능
//     }**
// }
```

# Solidity [11]: inheritance overrideing

## 함수 오버라이딩(Override)

***자식 컨트랙트에서 부모의 함수를 재정의하는 것***

- Solidity에서는 오버라이드 가능한 함수를 명시적으로 표시해야 함

| 키워드 | 위치 | 의미 |
| --- | --- | --- |
| `virtual` | 부모 함수에 사용 | “이 함수는 자식에서 재정의될 수 있다” |
| `override` | 자식 함수에 사용 | “이 함수는 부모 함수를 재정의한다” |

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Father {
    string public familyName = "Kim";
    string public givenName = "Jung";
    uint256 public money = 100;

    constructor(string memory _givenName) {
        givenName = _givenName;
    }

    function getFamilyName() view public returns(string memory)  {
        return familyName;
    }

    function getGivenName() view public returns(string memory)  {
        return givenName;
    }

    // 오버라이드(override) 가능한 함수에는 반드시 `virtual` 키워드를 붙인다.
    function getMoney() view public virtual returns(uint256)  {
        return money;
    }
}

contract Son is Father("James") {
    uint256 public earning = 0;

    function work() public {
        earning += 100;
    }

    // 부모 함수를 재정의(override)하는 함수에는 반드시 `override` 키워드를 붙인다.
    function getMoney() view public override returns(uint256)  {
        return money + earning;
    }
}
```

# Solidity [12]: multiple inheritance

- Solidity에서는 한 컨트랙트가 **여러 부모 컨트랙트를 동시에 상속** 받을 수 있음

```solidity
contract A { ... }
contract B { ... }
contract C is A, B { ... } // 다중 상속

```

- `C`는 `A`와 `B`의 모든 변수, 함수, 구조체 등을 상속받음
- 다만, 이때 부모 컨트랙트들 간에 **동일한 이름의 함수**가 존재할 경우, **충돌(conflict)이 발생**하므로 ****자식 컨트랙트는 반드시 **명시적으로 오버라이딩(override)** 해야 함

### 다중 상속 시 실행 순서 (C3 Linearization)

Solidity는 다중 상속 시 **C3 Linearization (위상 정렬)** 규칙을 따름

e.g.) `is Father, Mother`라고 선언하면 Son → Mother → Father 순서로 부모 생성자 및 함수가 호출됨

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract Father {
    uint256 public fatherMoney = 100;

    function getFatherName() public pure returns(string memory)  {
        return "KimJung";
    }

    function getMoney() view public virtual returns(uint256)  {
        return fatherMoney;
    }
}

contract Mother {
    uint256 public motherMoney = 200;

    function getMotherName() public pure returns(string memory)  {
        return "Leesol";
    }

    function getMoney() view public virtual returns(uint256)  {
        return motherMoney;
    }
}

// 같은 이름의 함수를 가진 두 개 이상의 contract 상속 시
// 자식 contract해서 오버라이딩 필수
contract Son is Father, Mother {
    function getMoney() public view **override(Father, Mother)** returns(uint256)  {
        return fatherMoney + motherMoney;
    }
}
```

# Solidity [13]: event definition

## Event

- Solidity에서 **이벤트(Event)** 는 `print`문 대신 **트랜잭션 로그에 데이터를 저장하는 기능**
- 블록체인 상에 불변(immutable) 로그로 기록되며, 외부 애플리케이션(DApp, Web3.js 등)에서 조회 가능
- 주로 상태 변화 기록이나 알림 기에 사용됨

### definition

```solidity
event EventName(type1 parameter1, type2 parameter2, ...);
// 이벤트는 컨트랙트 내부에 선언만 해두고, emit 키워드를 통해 발생시킨다.

emit EventName(value1, value2);
```

---

```solidity
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

```

- 실행 시 `Info("KimDaein", 1000)` 로그가 블록체인에 저장됨
- Solidity에는 `print`가 없기 때문에 콘솔에는 출력되지 않지만, Remix IDE의 “Logs” 탭이나 Etherscan에서 확인할 수 있음

![image.png](image.png)

# Solidity [13]: indexed

## **Solidity 이벤트의 indexed 키워드**

- `indexed`는 이벤트(event)의 특정 매개변수를 **검색 가능한 필드(indexed parameter)** 로 지정하는 키워드
- 이벤트 발생 시 `indexed`가 붙은 값은 로그의 **topics 영역**에 저장되어, 외부에서 **필터링 및 검색이 가**
    - `indexed`가 붙지 않은 나머지 필드는 `data` 영역에 저장
- `string`, `array`는 직접 인덱싱 불가하고, 해시값으로 저장

### 문법 구조

```solidity
event EventName(type1 indexed param1, type2 param2);
```

- `indexed` 키워드가 붙은 매개변수는 색인(indexed)으로 처리
- 블록체인 상에서 특정 값에 대한 **이벤트 검색(Filter)** 이 가능
- 하나의 이벤트에서 최대 **3개까지 indexed 필드**를 지정 가능

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/* Solidity Event의 indexed 키워드
- 이벤트(event)는 블록체인 로그에 데이터를 저장하기 위한 기능
- indexed 키워드는 이벤트의 특정 매개변수를 "검색 가능한 필드"로 지정
  (즉, 이벤트를 필터링하거나 특정 값으로 조회할 수 있도록 함)
*/
contract lec14 {
    // indexed 없는 이벤트 → 단순 로그로 저장 (검색 불가)
    event numberTracker(uint256 num, string st);
    // indexed 있는 이벤트 → num 필드를 색인(index)으로 지정 (검색 가능)
    event numberTracker2(uint256 indexed num, string str);

    uint256 num = 0;
    // 이벤트 발생 함수
    function PushEvent(string memory _str) public {
        emit numberTracker(num, _str);
        emit numberTracker2(num, _str);
        num++;
    }
```

# Solidity [14]: Super

- `super`는 자식 컨트랙트에서 **부모 컨트랙트의 함수나 이벤트를 호출할 때 사용하는 키워드**
- 특히 부모의 함수를 오버라이드한 뒤에도 **원래 부모 함수의 동작을 유지하면서** 자식 로직을 추가할 때 자주 사용
- 다중 상속 시에는 상속 순서(C3 Linearization)에 따라 가장 가까운 부모의 함수가 실행
- 오버라이딩된 함수 내부에서 부모의 함수를 명시적으로 실행할 때 사용

### 문법 구조

```solidity
super.functionName();
```

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

/*
super 키워드
- 자식 컨트랙트에서 부모 컨트랙트의 함수를 호출할 때 사용
- 오버라이딩(override)된 함수 내에서 부모의 원래 동작을 함께 실행하고 싶을 때 유용
*/

contract Father {
    // 이벤트: 아버지 이름 출력용
    event FatherName(string name);

    // virtual: 자식 컨트랙트에서 오버라이드 가능하도록 설정
    function who() public virtual {
        emit FatherName("KimDaeho");
    }
}

contract Son is Father {
    // 이벤트: 아들의 이름 출력용
    event SonName(string name);

    // override: 부모의 who() 함수를 재정의
    function who() public override {
        // super.who() → 부모(Father)의 who() 함수 실행
        super.who();

        // 자신의 이벤트 추가 실행
        emit SonName("KimJin");
    }
}
```

# Solidity [16]: 다중 상속(Multiple Inheritance)과 super 호출 순서

- Solidity에서는 하나의 컨트랙트가 **여러 부모 컨트랙트를 동시에 상속 가능**
- 이때 같은 이름의 함수가 여러 부모에 존재할 경우, 자식 컨트랙트는 반드시 **override(부모1, 부모2)** 형태로 재정의해야 함
- 다중 상속 환경에서는 “상속 선언 순서의 역순(reverse order)”으로 부모 함수가 실행됨

## C3 Linearization

- Solidity는 다중 상속에서 호출 순서를 결정하기 위해 **C3 Linearization(선형화)** 알고리즘을 사용
- 이 규칙에 따라 함수 호출 순서는 “가장 마지막에 상속된 부모부터 차례로” 수행되도록 보장됨

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

/*
다중 상속(Multiple Inheritance)과 super 호출 순서
- Solidity는 다중 상속 시 'C3 Linearization' 방식을 따른다.
- super 키워드를 사용하면, 상속 순서의 '역순'으로 부모 컨트랙트의 함수가 호출된다.
*/

contract Father {
    event FatherName(string name);
    function who() public virtual {
        emit FatherName("KimDaeho");
    }
}

contract Mother {
    event MotherName(string name);
    function who() public virtual {
        emit MotherName("Leesol");
    }
}

contract Son is Father, Mother {
    function who() public override(Father, Mother) {
        **// super.who() → 상속 순서의 역순(Mother → Father)으로 실행
        super.who();
    }**
}
```

- `Son`은 `Father`와 `Mother` 두 부모를 상속
- `super.who()` 호출 시:
    - Solidity는 **상속 선언 순서의 역순**으로 실행
    - 즉, `is Father, Mother` → `Mother → Father` 순서로 호출
- 따라서 이 코드 실행 시 두 이벤트가 순서대로 발생