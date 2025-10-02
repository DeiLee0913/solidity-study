// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.7.0 < 0.9.0;

contract lec2 {
    // Solidity three data type categories:
    // 1. Value types: boolean, bytes, address, unit
    // 2. Reference types :string, Arrays, struct
    // 3. Mapping type: key-value storage

    // ---------- Boolean ----------
    bool public b = false;

    // Logical Operations
    bool public b1 = !false;            // true
    bool public b2 = false || true;     // true
    bool public b3 = false == true;     // false
    bool public b4 = false && true;     // false
   
    // ---------- Bytes ----------
    bytes4 public bt = 0x12345678;
    bytes public bt2 = "STRING";

    // ---------- Address ----------
    address public addr = 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8;

    // ---------- Integer ----------
    // int vs uint

    // int8: -128 ~ 127 = (-2^7 ~ 2^7 - 1)
    int8 public it = 4;
    
    // uint256: = 0 ~ 255 = 0 ~ 2^256 - 1
    uint256 public uit = 132213;

    // uint8: 0 ~ 255 (1바이트, 8비트)
    uint8 uit2 = 255;
    // uint8 public uit2 = 256;  -> Error 발생
}