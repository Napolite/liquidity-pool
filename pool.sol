//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";


interface pool{
    function deposit(address tokenAddr,uint amount) external;
    function withdrawal(address token, address to, uint256 amount) external;
    function swap(address fromToken, address toToken,address to, uint256 amount) external;
}
contract Pool{

    IERC20 public token;
    mapping(address => mapping(address => uint)) balances;

    function deposit(address tokenAddr, uint amount) external{
        token = IERC20(tokenAddr);
        if(token.balanceOf(msg.sender) >= amount) revert( "You don't have enough tokens to swap with");
        if(token.allowance(msg.sender, address(this)) >= amount) token.transferFrom(msg.sender, address(this), amount);
        else {
            token.approve(address(this), 0);
            token.approve(address(this), amount);
            token.transferFrom(msg.sender, address(this), amount);
            balances[msg.sender][tokenAddr] += amount;      
        }
    }

    function withdrawal(address tokenAddr, uint amount) external{
        token = IERC20(tokenAddr);
        if(balances[msg.sender][tokenAddr] >= amount) revert("user does not have enough deposit for this withdrawal");
        
        token.transfer(msg.sender, amount);
        balances[msg.sender][tokenAddr] -= amount;
    }
}