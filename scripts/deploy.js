async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  // Step 1: Import necessary modules and contracts
  const Token = await ethers.getContractFactory('HeroToken');
  const TicketExtended = await ethers.getContractFactory('TicketExtended');

  // Step 2: Fetch contract source code
  const TokenContract = await Token.deploy('HeroToken', 'HT');
  const TicketExtendedContract = await TicketExtended.deploy();

  console.log('Token contract address:', TokenContract.target);
  console.log(
    'TicketExtended contract address:',
    TicketExtendedContract.target
  );
}
// Execute the deploy function
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
