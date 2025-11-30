// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {CryptoCrowd} from "../src/CryptoCrowd.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract CryproCrowdTest is Test {
    CryptoCrowd crowd;

    address creator = address(0xA1);
    address alice = address(0xB2);
    address bob = address(0xC3);

    function setUp() external {
        vm.prank(creator);
        crowd = new CryptoCrowd();
    }

    // Test Campaign Creation
    function testCreateCampaign() external {
        vm.prank(creator);
        crowd.createCampaign(5 ether, 7);

        (address cr, uint256 goal, , , ,) = crowd.campaigns(1);
        assertEq(cr, creator);
        assertEq(goal, 5 ether);
    }

    // Test Contribution
    function testContribution() external {
        vm.prank(creator);
        crowd.createCampaign(5 ether, 7)

        vm.prank(alice);
        crowd.contribute{value: 2 ether}(1);

        assertEq(crowd.contributions(1, alice) 2 ether);
    }

    // Test Failed Claim Before Deadline
    function testCannotClaimBeforeDeadline() external {
        vm.prank(creator);
        crowd.createCampaign(1 ether, 5);

        vm.prank(alice);
        crowd.contribute{value: 1 ether}(1)

        vm.prank(creator);
        vm.expectRevert(CryptoCrowd.DeadlineNotReached.selector);
        crowd.claimFunds(1);
    }

    // Test Claim Success
    function testOwnerCanClaimAfterGoalReached() external {
        vm.prank(creator);
        crowd.createCampaign(1 ether, 5);

        vm.prank(alice);
        crowd.contribute{value: 2 ether}(1);

        // Fast-forward time to after deadline
        vm.warp(block.timestamp + 6 days);

        uint256 creatorBalanceBefore = creator.balance;

        vm.prank(creator);
        crowd.claimFunds(1);

        assertEq(creator.balance, creatorBalanceBefore + 2 ether);
    }

    // Test Refund Logic
    function testRefund() external {
        vm.prank(creator);
        crowd.createCampaign(5 ether, 5);

        vm.prank(alice);
        crowd.contribute{value: 1 ether}(1);

        vm.warp(block.timestamp + 6 days);

        vm.prank(alice);
        crowd.refund(1);

        assertEq(alice.balance, 1 ether);
    }

    // Test No Contribution Refund Revert
    function testRefundFailsWithoutContribution() external {
        vm.prank(creator);
        crowd.createCampaign(5 ether, 5);

        vm.warp(block.timestamp + 6 days);

        vm.prank(bob);
        vm.expectRevert(CryptoCrowd.NoContribution.selector);
        crowd.refund(1);
    }
}