// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * @title Milestone-Based Crowdfunding
 * @author ZerosAndOnes
 * @notice 
 * @dev
 */

import {ReentrancyGuard} from "../lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract CryptoCrowd is ReentrancyGuard {

    // Errors
    error NotCampaignOwner();
    error CampaignDoesNotExist();
    error DeadlineNotReached();
    error GoalNotReached();
    error AlreadyClaimed();
    error DeadlineNotValid();
    error GoalMustBeAboveZero();
    error NoContribution();

    // Events
    event CampaignCreated(
        uint256 indexed campaignId,
        address indexed creator,
        uint256 goal,
        uint256 deadline
    );
    event ContributionMade(
        uint256 indexed campaignId,
        address indexed contributor,
        uint256 amount
    );
    event FundsClaimed(
        uint256 indexed campaignId,
        uint256 amount
    );
    event Refunded(
        uint256 indexed campaignId,
        address indexed contributor,
        uint256 amount
    );

    // Constructor
    constructor() {
        i_admin = msg.sender; // deployer becomes admin
    }

    // Modifiers
    modifier onlyCampaignOwner(uint256 _id) {
        if (msg.sender != campaigns[_id].creator) {
            revert NotCampaignOwner();
        }
        _;
    }
    modifier campaignMustExist(uint256 _id) {
        if (!campaigns[_id].exists) {
            revert CampaignDoesNotExist();
        }
        _;
    }

    // State Variables
    uint256 public campaignCount;
    address public immutable i_admin;

    // Mappings
    mapping(uint256 => Campaign) public campaigns;
    // campaignId → contributor → amount
    mapping(uint256 => mapping(address => uint256)) public contributions;

    // Struct 
    struct Campaign {
        address creator;
        uint256 goal;
        uint256 deadline;
        uint256 totalFunded;
        bool claimed;
        bool exists;
    }

    // Functions

    // Create Campaign
    function createCampaign(uint256 _goal, uint256 _durationInDays) external {
        if (_goal == 0) {
            revert GoalMustBeAboveZero();
        }
        if (_durationInDays < 1) {
            revert DeadlineNotValid();
        }

        campaignCount++;
        uint256 deadline = block.timestamp + (_durationInDays * 1 days);

        campaigns[campaignCount] = Campaign({
            creator: msg.sender,
            goal: _goal,
            deadline: deadline,
            totalFunded: 0,
            claimed: false,
            exists: true
        });

        emit CampaignCreated(campaignCount, msg.sender, _goal, deadline);
    }

    // Contribute to Campaign
    function contribute(uint256 _campaignId) external payable nonReentrant {
        if (!campaigns[_campaignId].exists) revert CampaignDoesNotExist();
        Campaign storage c = campaigns[_campaignId];

        require(block.timestamp < c.deadline, "Campaign expired");
        require(msg.value > 0, "Must send ETH");

        c.totalFunded += msg.value;
        contributions[_campaignId][msg.sender] += msg.value;

        emit ContributionMade(_campaignId, msg.sender, msg.value);
    }

    // Claim Funds (Only if Goal Reached)
    function claimFunds(uint256 _campaignId) external nonReentrant {
        Campaign storage c = campaigns[_campaignId];

        if (!c.exists) revert CampaignDoesNotExist();
        if (msg.sender != c.creator) revert();
        if (block.timestamp < c.deadline) revert DeadlineNotReached();
        if (c.totalFunded < c.goal) revert GoalNotReached();
        if (c.claimed) revert AlreadyClaimed();

        uint256 amount = c.totalFunded;
        c.claimed = true;

        (bool sent, ) = payable(c.creator).call{value: amount}("");
        require(sent, "Transfer failed");

        emit FundsClaimed(_campaignId, amount);
    }

    // Refund Contributors if Goal Not Met
    function refund(uint256 _campaignId) external nonReentrant {
        Campaign storage c = campaigns[_campaignId];

        if (!c.exists) revert CampaignDoesNotExist();
        if (block.timestamp < c.deadline) revert DeadlineNotReached();
        if (c.totalFunded >= c.goal) revert GoalNotReached();

        uint256 contributedAmount = contributions[_campaignId][msg.sender];
        require(contributedAmount > 0, "Nothing to refund");

        contributions[_campaignId][msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: contributedAmount}("");
        require(sent, "Refund failed");

        emit Refunded(_campaignId, msg.sender, contributedAmount);
    }
}
}