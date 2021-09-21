// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {

    address[] holders;
    uint claimLockedUntil = 0;
    address contractOwner;

    constructor(string memory name_, string memory symbol_, uint _initialSupply, address[] memory _holders) public 
    ERC20(name_, symbol_) {
        require(_initialSupply > 0, "INITIAL_SUPPLY has to be greater than 0");
        require(_holders.length > 0, "At least 1 Holder address should be entered");
        require(_holders.length <= 10, "Only 10 holder address are allowed");
        _mint(msg.sender, _initialSupply * (10 ** decimals()));
        for(uint i = 0; i < _holders.length; i++) {
            holders.push(_holders[i]);
        }
        claimLockedUntil = block.timestamp;
        contractOwner = msg.sender;
    } 

    modifier onlyContractOwner() {
        require(
        msg.sender == contractOwner,
        "The caller is not the contract owner"
        );
        _;
  }

    function disperseFunds(uint amount) public onlyContractOwner {
        require(block.timestamp >= claimLockedUntil, "Can only disperse funds after an interval of 1 minute");
        uint numTokens = amount * (10 ** decimals());
        require(numTokens <= balanceOf(contractOwner), "The number of tokens are not enough for this transfer");
        uint tokensToEachAddress = numTokens / holders.length;
        for(uint i = 0; i < holders.length; i++) {
            transfer(holders[i], tokensToEachAddress);
        }
        claimLockedUntil = block.timestamp + 60;
    }
}