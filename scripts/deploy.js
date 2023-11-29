const { ethers, run } = require('hardhat');

const deploy = async (contractName, signer, args = []) => {
  const factory = await ethers.getContractFactory(contractName, signer);
  const contract = await factory.deploy(...args);

  await contract.deploymentTransaction().wait();

  return contract;
}

// Verify a contract
const verify = async (address, args = []) => {
  await run('verify:verify', {
    address: address,
    constructorArguments: args,
  }).catch((error) => { console.log(error); });
}

const main = async () => {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  const ERC6551Account = await deploy('ERC6551Account', deployer);
  console.log('ERC6551Account contract address:', ERC6551Account.target);

  const ERC6551Registry = await deploy('ERC6551Registry', deployer);
  console.log('ERC6551Registry contract address:', ERC6551Registry.target);

  const HeroTicket = await deploy('HeroTicket', deployer, [ERC6551Account.target, ERC6551Registry.target]);
  console.log('HeroTicket contract address:', HeroTicket.target);

  // const tx = await HeroToken.transferOwnership(HeroTicket.target);
  // await tx.wait();

  // console.log("Transferred HeroToken's ownership to HeroTicket");

  // Verify contracts
}
//Execute the deploy function
main()
  .then(() => {
    console.log('Deployment successful!');
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
