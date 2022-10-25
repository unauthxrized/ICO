// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WorkshopToken is ERC20 {
    constructor() ERC20("WORKSHOPTOKEN", "WRKT") {
        _mint(msg.sender, 100000 * 10 ** decimals());
    }
}