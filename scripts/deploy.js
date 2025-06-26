const hre = require("hardhat");

async function main() {
  const DAOVoting = await hre.ethers.getContractFactory("DAOVoting");
  const daoVoting = await DAOVoting.deploy();

  await daoVoting.deployed();

  console.log("DAO Voting contract deployed to:", daoVoting.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
