const HDWalletProvider = require("@truffle/hdwallet-provider"); // import HDWalletProvider package
const fs = require("fs"); // import fs (file system) module
const mnemonic = fs.readFileSync(".secret").toString().trim(); // read the contents of the .secret file and store the mnemonic

module.exports = {
  networks: {
    testnet: {
      provider: () =>
        new HDWalletProvider(
          mnemonic,
          `https://data-seed-prebsc-1-s1.binance.org:8545`
        ), // set up the provider using the mnemonic and the testnet endpoint
      network_id: 97, // set the network ID to 97 (Binance Smart Chain testnet)
      confirmations: 10, // set the number of confirmations to wait for before a transaction is considered final
      timeoutBlocks: 200, // set the number of blocks to wait before a transaction times out
      skipDryRun: true, // skip the dry run step when deploying contracts
    },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000 // set the timeout for mocha tests (currently commented out)
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.4", // specify the version of the Solidity compiler to use
    },
  },
};
