// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CurrencyExchangeOffice {
    
    address private owner;
    

    mapping (IERC20 => uint256) private rates;

    constructor() {
        owner = msg.sender;
    }

    function addCurrency(address coinAddress, uint256 initialSupply) public {
        require(msg.sender == owner, "Permission denied.");
        rates[ERC20(coinAddress)] = 1;
        ERC20(coinAddress).transferFrom(msg.sender, address(this), initialSupply);
    }

    function setRate(address token, uint256 rate) public {
        require(msg.sender == owner, "Permission denied.");
        rates[IERC20(token)] = rate;
    }

    function buy(address token, uint256 amount) public payable {
        ERC20 currentToken = ERC20(token);
        require(amount * rates[currentToken] <= msg.value, "Not enough amount");
        require(amount <= currentToken.balanceOf(address(this)), "Not enough tokens");

        currentToken.transfer(msg.sender, amount);
    }

    function sell(address token, uint256 amount) public payable {
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "Not enough amount");
        require(payable(msg.sender).send(rates[IERC20(token)] * amount), "Not enough tokens");
    }

    function destroySmartContract(address payable token) public {
        require(msg.sender == owner, "Permission denied.");
        selfdestruct(token);
    }
}
