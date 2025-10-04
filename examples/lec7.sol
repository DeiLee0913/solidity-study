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