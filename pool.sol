//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

interface IPool {
    function deposit(address tokenAddr, uint256 amount) external;
    function withdraw(address tokenAddr, uint256 amount) external;
    function swap(address from, address to, uint256 amount) external;
    function getSwapRate(address from, address to) external view returns (uint256);
    function balanceOf(address user, address tokenAddr) external view returns (uint256);
}

contract Pool is IPool {

    mapping(address => mapping(address => uint256)) public balances;

    function deposit(address tokenAddr, uint256 amount) external override {
        IERC20 token = IERC20(tokenAddr);
        require(token.balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(token.transferFrom(msg.sender, address(this), amount), "Deposit failed");
        balances[msg.sender][tokenAddr] += amount;
    }

    function withdraw(address tokenAddr, uint256 amount) external override {
        IERC20 token = IERC20(tokenAddr);
        require(balances[msg.sender][tokenAddr] >= amount, "Insufficient balance for withdrawal");
        require(token.transfer(msg.sender, amount), "Withdrawal failed");
        balances[msg.sender][tokenAddr] -= amount;
    }

    function getSwapRate(address from, address to) external view override returns (uint256) {
        IERC20 fromToken = IERC20(from);
        IERC20 toToken = IERC20(to);
        require(fromToken.balanceOf(address(this)) > 0, "Token does not exist on this pool");
        require(toToken.balanceOf(address(this)) > 0, "Token does not exist on this pool");
        return toToken.balanceOf(address(this)) / fromToken.balanceOf(address(this));
    } 

    function swap(address from, address to, uint256 amount) external override {
        IERC20 fromToken = IERC20(from);
        IERC20 toToken = IERC20(to);
        uint256 swapRate = getSwapRate(from, to);
        uint256 toAmount = amount * swapRate;

        require(toToken.balanceOf(address(this)) >= toAmount, "Not enough token on the contract for the transaction");
        require(fromToken.balanceOf(msg.sender) >= amount, "User does not have enough tokens for this transaction");

        require(fromToken.transferFrom(msg.sender, address(this), amount), "Cannot withdraw tokens");
        require(toToken.transfer(msg.sender, toAmount), "Cannot send tokens");
    }

    function balanceOf(address user, address tokenAddr) external view override returns (uint256) {
        return balances[user][tokenAddr];
    }
}
