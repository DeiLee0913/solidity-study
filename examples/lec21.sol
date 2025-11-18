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