// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.18;

// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

/**
 * @title Raffle Smart Contract Lottery
 * @author 0xvector
 * @notice Creating a simple randome raffle smart contract lottery
 * @dev Implementing Chainlink Vrfv2
 */

contract Raffle {
    address payable[] private s_players;

    /** State Variables */
    uint256 private constant REQUEST_COMFIRMATIONS = 3;
    uint256 private constant NUM_WORDS = 1;

    uint256 private immutable i_entranceFee;
    // @dev duration of the raffle in seconds.
    uint256 private immutable i_interval;
    uint256 private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    uint256 private lastTimeStamp;

    /** Events */
    event HasEnteredRaffle(address player);

    /** Errors */
    error NotEnoughEthSent();

    /** CONSTRUCTOR FUNCTION */
    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit
    ) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        lastTimeStamp = block.timestamp;
        i_vrfCoordinator = vrfCoordinator;
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert NotEnoughEthSent();
        }

        s_players.push(payable(msg.sender));
        emit HasEnteredRaffle(msg.sender);
    }

    function pickWinner() external {
        if (block.timestamp - lastTimeStamp < i_interval) {
            revert();
        }
        // Will revert if subscription is not set and funded.
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, // gas lane
            i_subscriptionId, // individual id
            REQUEST_COMFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
    }

    /**Getter Funtions */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
