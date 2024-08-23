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
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    error NotEnoughEthSent();

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        if (msg.value < i_entranceFee) {
            revert NotEnoughEthSent();
        }

        s_players.push(payable(msg.sender));
    }

    function pickWinner() public {}

    /**Getter Funtions */
    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
