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

const deployAndVerifyContracts = async () => {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  // read javascript file as string
  const source = fs.readFileSync(process.cwd() + '/api-request.js').toString();

  const ticketImageConsumerArgs = [
    '0x6E2dc0F9DB014aE19888F539E59285D2Ea04244C', // router address
    source, // source code
    '0x66756e2d706f6c79676f6e2d6d756d6261692d31000000000000000000000000', // donId
    540, // subscriptionId
    300000, // gas limit
  ];

  let TicketImageConsumer = await deploy('TicketImageConsumer', deployer, ticketImageConsumerArgs);
  console.log(
    'TicketImageConsumer contract address:',
    TicketImageConsumer.target
  );

  const heroTicketArgs = [
    "0x2683f4e961890eFE9Ae514A0Fbe747C990E882E4",
    "0x8aa31923f0A7eE8dfaDF030354f117be7B74a78d",
    TicketImageConsumer.target,
  ];

  let HeroTicket = await deploy('HeroTicket', deployer, heroTicketArgs);
  console.log('HeroTicket contract address:', HeroTicket.target);

  const transferOwnershipTx = await TicketImageConsumer.transferOwnership(HeroTicket.target);

  const transferOwnershipReceipt = await transferOwnershipTx.wait();

  console.log("ownership transfer requested:", transferOwnershipReceipt.hash);

  const acceptOwnershipTx = await HeroTicket.acceptOwnership();

  const acceptOwnershipReceipt = await acceptOwnershipTx.wait();

  console.log("ownership transfer accepted:", acceptOwnershipReceipt.hash);

  console.log("owner of TicketImageConsumer:", await TicketImageConsumer.owner());

  await verify(TicketImageConsumer.target, ticketImageConsumerArgs);

  await verify(HeroTicket.target, heroTicketArgs);
};

const deployAndVerifyContracts2 = async () => {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  const tokenArgs = [
    "HeroToken",
    "HERO",
  ];

  const Token = await deploy('HeroToken', deployer, tokenArgs);

  // verify contracts
  await verify(Token.target, tokenArgs);
}

const requestImage = async () => {
  const [deployer] = await ethers.getSigners();

  const HeroTicket = await ethers.getContractFactory('HeroTicket', deployer);

  const heroTicket = HeroTicket.attach("0x0310F71bf9631d8DaB3e70181250a223411e867c");

  /*
  const requestTicketImageTx = await heroTicket.requestTicketImage(
    process.env.ENCRYPTED_SECRET_URLS,
    'Seoul, South Korea',
    'BTS Concert'
  );

  const requestTicketImageReceipt = await requestTicketImageTx.wait();


  console.log("requestTicketImageTx:", requestTicketImageReceipt);
*/

  const requestData = await heroTicket.requests("0x845F3C8A745376052FBF837CD25934B263ADE7F25F14E4D2D0E513A106C4FAAC");

  console.log("requestData:", requestData);
}

const main = async () => {
  // Deploy and verify contracts
  // await deployAndVerifyContracts();
  await deployAndVerifyContracts2();

  //await requestImage();
  /*
    TicketImageConsumer contract address: 0xE1F034C42A96679f196869c987AF77aa8E123C10
    HeroTicket contract address: 0xfF14bCd3bF0F5614334c8DBa02FDC9f78dFBbc81
  */
};

main()
  .then(() => {
    console.log('Deployment successful!');
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
