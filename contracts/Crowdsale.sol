// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract Crowdsale is Ownable, Pausable {
    AggregatorV3Interface private immutable _PRICEFEED;
    IERC20 private immutable _TOKEN;

    uint256 private constant _RATE = 10;

    constructor(address _aggregator, address _token) {
        _PRICEFEED = AggregatorV3Interface(_aggregator);
        _TOKEN = IERC20(_token);
    }
    
    function buyTokens() external payable whenNotPaused {
        uint256 _wei = msg.value;
        uint256 _usd = _getConversionRate(_wei);
        uint256 _tokensToTransfer = _usd * _RATE;
        _TOKEN.transfer(msg.sender, _tokensToTransfer);
    }

    // OWNER

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
        uint256 _tokenbalance = _TOKEN.balanceOf(address(this));
        _TOKEN.transfer(owner(), _tokenbalance);
    }

    function setActive() external onlyOwner {
        _unpause();
    }

    function setInactive() external onlyOwner {
        _pause();
    }

    /* GETTERS */

    function getPrice() public view returns (uint256) {
         (,int256 price,,,) = _PRICEFEED.latestRoundData();
        return uint256(price * (1 * 10 ** 10));
    }

    function _getConversionRate(uint256 _amount) private view returns (uint256) {
        uint256 _maticPrice = getPrice();
        uint256 _maticInUSD = (_maticPrice * _amount) / (1 * 10 ** 18);
        return _maticInUSD;
    }

    function getTokenBalance() public view returns (uint256) {
        uint256 _balance = _TOKEN.balanceOf(address(this));
        return _balance;
    }

    function getMaticBalance() public view returns (uint256) {
        address _this = address(this);
        uint256 _balance = _this.balance;
        return _balance;
    }

    function getUSDBalance() public view returns (uint) {
        uint256 _balance = getMaticBalance();
        uint256 _usd = _getConversionRate(_balance);
        return _usd;
    }
}