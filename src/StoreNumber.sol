// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract StoreNumber {
  uint number;

  function set(uint value) public {
    number = value;
  }

  function get() public view returns (uint storedNumber) {
    return number;
  }
}
