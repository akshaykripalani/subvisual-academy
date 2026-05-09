// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Guestbook} from "src/Guestbook.sol";

contract GuestbookScript is Script {
    function run() public {
        vm.startBroadcast();

        new Guestbook();

        vm.stopBroadcast();
    }
}
