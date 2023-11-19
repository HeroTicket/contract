async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with the account:', deployer.address);

  // Step 1: Import necessary modules and contracts
  const Ticket = await ethers.getContractFactory('Ticket');
  const TicketExtended = await ethers.getContractFactory('TicketExtended');

  // Step 2: Fetch contract source code
  const TicketContract = await Ticket.deploy('Clean Mile DNFT', 'CMD');
  const TicketExtendedContract = await TicketExtended.deploy();

  console.log('Ticket contract address:', TicketContract.target);
  console.log('TicketExtended contract address:', TicketExtended.target);
}
// Execute the deploy function
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
