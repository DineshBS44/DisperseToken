const Token = artifacts.require("Token");

const totalSupply = 100000000;

const holders = ["0x5e5fbc182a07C5DcaBB5d10ecA73796028591DDa", "0x6316606851BB4E129Aa6Ba9dCC96d003F184D97A", "0x3D6D47123899bc92a10c9EFC1F15D1FaBde3473b"];

module.exports = async function(deployer) {
  await deployer.deploy(Token, "Disperse", "DSP", totalSupply, holders);
  let token = await Token.deployed();
};