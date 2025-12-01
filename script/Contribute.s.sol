// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {CryptoCrowd} from "../src/CryptoCrowd.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

contract Contribute is Script {
    CryptoCrowd crowd = CryptoCrowd(0xYourDeployedAddress);

    function run() external {
        vm.startBroadcast();
        crowd.contribute{value: 1 ether}(1);
        vm.stopBroadcast();
    }
}