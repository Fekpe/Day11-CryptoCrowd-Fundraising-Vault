// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {CryptoCrowd} from "../src/CryptoCrowd.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

contract DeployCryptoCrowd is Script {
    function run() external returns (CryptoCrowd) {
        vm.startBroadcast();

        CryptoCrowd crowd = new CryptoCrowd(0xYourDeployedAddress);

        vm.stopBroadcast();
        return crowd;
    }
}