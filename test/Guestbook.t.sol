// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Guestbook} from "../src/Guestbook.sol";

contract GuestbookTest is Test {
    Guestbook guestbook;

    event MessagePosted(uint256 id, address indexed author);

    function setUp() public {
        guestbook = new Guestbook();
    }

    function test_getMessageCountEmpty() public view {
        uint256 msgCount = guestbook.getMessageCount();
        assertEq(msgCount, 0);
    }

    function test_messageCreation() public {
        uint256 msgCountOld = guestbook.getMessageCount();
        string memory testMessage = "Hello World";

        guestbook.writeToBook(testMessage);
        Guestbook.GuestMessage memory msgFromList = guestbook.getMessageById(msgCountOld + 1);

        assertEq(msgFromList.content, testMessage);
        assertEq(msgFromList.id, msgCountOld + 1);
    }

    function test_invalidMessageEmpty() public {
        vm.expectRevert(bytes(guestbook.errorMessageEmpty()));

        guestbook.writeToBook("");
    }

    function testFuzz_getRandomMessages(uint256 x) public {
        guestbook.writeToBook("First");
        guestbook.writeToBook("Second");
        guestbook.writeToBook("Third");

        if (x >= 1 && x <= 3) {
            Guestbook.GuestMessage memory msgFromList = guestbook.getMessageById(x);
            assertEq(msgFromList.id, x);
        } else {
            vm.expectRevert();
            guestbook.getMessageById(x);
        }
    }

    function test_ensureTimestampMatchesBlockTimestamp() public {
        uint256 expectedTimestamp = 123123;
        vm.warp(expectedTimestamp);

        guestbook.writeToBook("hello world");
        assertEq(guestbook.getMessageById(1).timestamp, expectedTimestamp);
    }

    function test_ensureAuthorMatchesCaller() public {
        address alice = address(0xaaaa);
        vm.prank(alice);
        guestbook.writeToBook("Bob's Wife");

        assertEq(guestbook.getMessageById(1).author, alice);
    }

    function test_eventEmittedOnTransaction() public {
        vm.expectEmit(true, false, false, true);
        emit MessagePosted(1, address(this));

        guestbook.writeToBook("Hello Event");
    }
}
