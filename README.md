Building a Solidity liquidity pool
[What is a Liquidity Pool]()
[What you need]()
[Building A Liquidity Pool]()
[Conclusion]()


What is a Liquidity Pool

What a liquidity pool is, is not very mysterious, neither is it something as complicated as rocket science or The barber of seville. In its simplest form, it is a contract that allows people to deposit assets. Those assets become used for various trading services like Yield farming, Swapping, Lending, and other decentralized trading.

What we are going to build is a simple Liquidity pool that allows users deposit and withdraw tokens, and we will also implement a simple swap feature for our liquidity pool.

What you need

Basic knowledge of Solidity. 
Remix IDE.
and your attention.

Let’s Begin

Building A Liquidity Pool

We will start by defining our pragma version to use solidity compiler version 0.8.0.

/// Pragma solidity 0.8.0;

Now this is not important, but it is advisable to have an interface so you can map out the behavior of your smart contract, but it is not compulsory. We will, however, write one to determine how our contract will behave.



/// interface Pool{
   function deposit(address tokenAddr,uint256 amount) external;
   function withdrawal(address token, uint256 amount) external;
   function swap(address from, address to, uint256 amount) external;
   function swapRates(address from, address to) external view returns (uint256);
   function balanceOf(address user, address token) external view returns (uint256);
}///



As you can see from our interface, we will build a deposit function, a withdrawal function, a Swap function, a function to determine swap rates and a function to get balances.

Now we are going to start the main contract.



///contract Pool is pool{


   mapping(address => mapping(address => uint)) public balances;
}///

We have our balances variable as our only global variable because it is the only variable we are going to update throughout the contract, not just one function.

Next we start with our deposit function.

But before we can build a deposit function, we will need a token, or a variable that behaves like a token. For this we will need to import the openzeppelin ERC20 interface at the top of the file.

pragma solidity ^0.8.0;




import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

Now we can use erc20 token functions in our contract.



///function deposit(address tokenAddr, uint amount) external {
       IERC20 token = IERC20(tokenAddr);
       require(token.balanceOf(msg.sender) >= amount, "Insufficient balances");
       require(token.transferFrom(msg.sender,address(this), amount), "Deposit tokens failed");
       balances[msg.sender][tokenAddr] += amount;
   }///



For our deposit function, we take two arguments. address tokenAddr and uint256 amount. The token address is used to instantiate our token, and the amount is the value of our deposit. First, we require the user’s balance to be up to the amount he wants to deposit, else we revert with an “Insufficient balance” message. Next line, we transfer the tokens from the user with the transferFrom function, and if that fails, we return an error to tell that it has failed, but if it goes through, we update the balance of the sender with the amount of that token that he deposited.

Next we need a feature that allows users to remove or reclaim their tokens.



///function withdrawal(address tokenAddr, uint amount) external{
       IERC20 token = IERC20(tokenAddr);
        require(balances[msg.sender][tokenAddr] >= amount,"Insufficient balance for withdrawal");
      
       require(token.transfer(msg.sender, amount), "Withdraw tokens failed");
       balances[msg.sender][tokenAddr] -= amount;
   }///



For our withdrawal function we use 2 arguments again, and we do the same process over again, although this time, we use token.transfer to the user address and we subtract their balance.

Now we are done with the basic implementation of a liquidity pool. Like I said earlier, a Liquidity pool is a contract where tokens are deposited to aid decentralised trading. Now we can implement a DeFi protocol, since we have access to our pool. The most common trading protocol is a Swap protocol.

First we need a function to get our swap rates. We need two arguments, the token swapped from and the token swapped to. Then we check how much of each token our contract is holding, and we divide the balance of the from token by the to token.



///function swapRates(address from, address to) view public returns (uint256){
       IERC20 fromToken = IERC20(from);
       IERC20 toToken = IERC20(to);


       require(fromToken.balanceOf(address(this)) != 0, "This token does not exist on this pool");
       require(toToken.balanceOf(address(this)) != 0, "this token does not exist on this pool");


       return toToken.balanceOf(address(this))/fromToken.balanceOf(address(this));
   }///




Now that we have our rates function, we can now go ahead to create our swap feature. The contract will receive the tokens from the user, and multiply the amount of tokens received by the rates. 



///function swap(address from, address to, uint amount ) external{
       IERC20 fromToken = IERC20(from);
       IERC20 toToken = IERC20(to);
       uint256 rates = swapRates(from, to);


       require(toToken.balanceOf(address(this)) >= amount*rates, "Not enough token on the contract for the transaction");
       require(fromToken.balanceOf(msg.sender) >= amount, "User does not have enough for this transaction");


       require(fromToken.transferFrom(msg.sender, address(this), amount), "Cannot withdraw tokens");
       require(toToken.transfer( msg.sender, amount*rates), "Cannot send tokens");
   }///


Conclusion

So, That is basically the implementation of a basic liquidity pool. Although many emerging DeFis fork, or copy heavily from Uniswap protocol , it is important to understand how the basics work and how to transverse the uniswap code.

Happy Hacking.
