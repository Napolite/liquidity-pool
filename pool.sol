//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";


interface Pool{
    function deposit(address token, amount) external;
    function withdrawal(address token, address to, uint256 amount) external;
    function swap(address fromToken, address toToken,address from,address to, uint256 amount);
}
contract Pool is Pool{

    

}