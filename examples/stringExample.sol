// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract StringExample {
    // string의 저장 위치: storage, memory, calldata
    // 1. storage: 상태 변수
    string public greeting = "Hello Solidity";  // 영구 저장

    // 2. memory: 함수 내에서 문자열 처리(임시)
    function setGreeting(string memory _text) public pure returns (string memory) {
        // 메모리 상에서 문자열을 합쳐 반환
        return string(abi.encodePacked("Hi, ", _text));
    }

    // 3. calldata: external 함수의 읽기 전용 매개변수
    function echo(string calldata _input) external pure returns (string calldata) {
        return _input;  // 읽기만 가능, 수정 불가 
    }

    function getFirstLetter(string memory _word) public pure returns (bytes1) {
        bytes memory byteWord= bytes(_word);    // string -> bytes 변환
        return byteWord[0];    // 첫 글자 반환
    }
    
    function getLength(string memory _word) public pure returns (uint256) {
        return bytes(_word).length;     // 문자열 길이 반환
    }
}