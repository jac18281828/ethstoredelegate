// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StoreNumber.sol";

contract StoreNumberTest is Test {
    StoreNumber storeNumber;

    function setUp() public {
        storeNumber = new StoreNumber();
    }

    function testGetInitialValue() public {
        assertTrue(storeNumber.get() == 0);
    }

    function testSetValue() public {
        uint256 x = 300;
        storeNumber.set(x);
        assertTrue(storeNumber.get() == 300);
    }
}
