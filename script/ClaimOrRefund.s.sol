// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {CryptoCrowd} from "../src/CryptoCrowd.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

contract ClaimOrRefund is Script {
    CryptoCrowd crowd = CryptoCrowd(0xYourDeployedAddress);

    function run() external {
        vm.startBroadcast();

        // For campaign owner;
        // crowd.claimFunds(1);

        // For contributor
        // crowd.refund(1);

        vm.stopBroadcast();
    }
}