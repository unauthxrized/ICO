// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/mocks/MockAggregator.sol";

contract AggregatorV3Mock is MockAggregator {

    constructor () {
        setLatestAnswer(1 * 10 ** 8);
    }
    function latestRoundData() external view returns (uint80, int, uint, uint, uint80) {
        return (1, latestAnswer(), 1, 1, 1);
    }
}
