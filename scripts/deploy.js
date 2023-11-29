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

const main = async () => {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  const ERC6551Account = await deploy('ERC6551Account', deployer);
  console.log('ERC6551Account contract address:', ERC6551Account.target);

  const ERC6551Registry = await deploy('ERC6551Registry', deployer);
  console.log('ERC6551Registry contract address:', ERC6551Registry.target);

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
    ERC6551Account.target,
    ERC6551Registry.target,
    TicketImageConsumer.target,
  ]);
  console.log('HeroTicket contract address:', HeroTicket.target);

  HeroTicket = await ethers.getContractFactory('HeroTicket', deployer);

  const heroTicket = HeroTicket.attach(
    '0xE06364a013C37375ebFDDf0fb01C3262Ed385D69'
  );

  const tx = await heroTicket.requestTicketImage(
    process.env.ENCRYPTED_SECRET_URLS,
    'Seoul',
    'YOASOBI Concert'
  );

  console.log(tx);

  // 15초 대기
  await new Promise((resolve) => setTimeout(resolve, 15000));

  const tx2 = await heroTicket.requests(tx.data);

  console.log(tx2);
  // TicketImageConsumer = await ethers.getContractFactory(
  //   'TicketImageConsumer',
  //   deployer
  // );

  // const ticketImageConsumer = TicketImageConsumer.attach(
  //   '0xE06364a013C37375ebFDDf0fb01C3262Ed385D69'
  // );

  // const tx = await ticketImageConsumer.requestTicketImage(
  //   process.env.ENCRYPTED_SECRET_URLS,
  //   'Seoul',
  //   'YOASOBI Concert'
  // );

  // console.log(tx);

  // const request = await ticketImageConsumer.requests(
  //   '0xbb8ea11768b3c9106441b9588cc4fbe20915f30b78771cd237bec0e408dafd85'
  // );

  // console.log(request);

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
