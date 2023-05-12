// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Shekel is ERC20 {
    constructor(uint256 initialSupply) payable  ERC20("SHEKEL", "SKL") {
        _mint(msg.sender, initialSupply);
    }
}
