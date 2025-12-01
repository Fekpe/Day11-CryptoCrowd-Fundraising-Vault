// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {CryptoCrowd} from "../src/CryptoCrowd.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

contract CreateCampaign is Script {
    CryptoCrowd crowd = CryptoCrowd(0xYourDeployedAddress); 

    function run() external {
        vm.startBroadcast();
        crowd.createCampaign(5 ether, 7); // goal: 5 ETH | deadline: 7 days
        vm.stopBroadcast();
    }
}