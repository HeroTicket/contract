const { ethers, run } = require('hardhat');
const fs = require('fs');
const { time } = require('console');

const deploy = async (contractName, signer, args = []) => {
  const factory = await ethers.getContractFactory(contractName, signer);
  const contract = await factory.deploy(...args);

  await contract.deploymentTransaction().wait();

  return contract;
};

// Verify a contract
const verify = async (address, args = []) => {
  await run('verify:verify', {
    address: address,
    constructorArguments: args,
  }).catch((error) => {
    console.log(error);
  });
};

const deployContracts = async () => {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  // read javascript file as string
  const source = fs.readFileSync(process.cwd() + '/api-request.js').toString();

  let TicketImageConsumer = await deploy('TicketImageConsumer', deployer, [
    '0x6E2dc0F9DB014aE19888F539E59285D2Ea04244C', // router address
    source, // source code
    '0x66756e2d706f6c79676f6e2d6d756d6261692d31000000000000000000000000', // donId
    540, // subscriptionId
    300000, // gas limit
  ]);

  console.log(
    'TicketImageConsumer contract address:',
    TicketImageConsumer.target
  );

  let HeroTicket = await deploy('HeroTicket', deployer, [
    "0x2683f4e961890eFE9Ae514A0Fbe747C990E882E4",
    "0x8aa31923f0A7eE8dfaDF030354f117be7B74a78d",
    TicketImageConsumer.target,
  ]);
  console.log('HeroTicket contract address:', HeroTicket.target);

  const transferOwnershipTx = await TicketImageConsumer.transferOwnership(HeroTicket.target);

  const transferOwnershipReceipt = await transferOwnershipTx.wait();

  console.log("ownership transfer requested:", transferOwnershipReceipt.hash);

  const acceptOwnershipTx = await HeroTicket.acceptOwnership();

  const acceptOwnershipReceipt = await acceptOwnershipTx.wait();

  console.log("ownership transfer accepted:", acceptOwnershipReceipt.hash);

  console.log("owner of TicketImageConsumer:", await TicketImageConsumer.owner());
};

const main = async () => {
  // Deploy contracts
  // await deployContracts();

  const [deployer] = await ethers.getSigners();

  const HeroTicket = await ethers.getContractFactory('HeroTicket', deployer);

  const heroTicket = HeroTicket.attach("0xB97b45C18C9ac6C9a1da1e275B660B1116EE3599");

  // const requestTicketImageTx = await heroTicket.requestTicketImage(
  //   process.env.ENCRYPTED_SECRET_URLS,
  //   'Seoul',
  //   'YOASOBI Concert'
  // );

  // const requestTicketImageReceipt = await requestTicketImageTx.wait();


  // console.log("requestTicketImageTxHash:", requestTicketImageReceipt.hash);


  const requestData = await heroTicket.requests("0x6EF9D4C6513FF9362341DED59569326758ABF124703EA224E45D33F2545CFB58");

  console.log("requestData:", requestData);

  // Verify contracts
};
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
