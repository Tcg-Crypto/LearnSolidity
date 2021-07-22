// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract token2erc20 is ERC20 {
    constructor(uint256 initialSupply) public ERC20("Silver", "SLVR") {
        _mint(msg.sender, initialSupply);
    }
}