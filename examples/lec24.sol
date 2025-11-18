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