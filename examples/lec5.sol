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
