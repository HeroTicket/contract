// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITicketExtended {
    event minted(uint256 tokenId);

    function mint(
        address to,
        string memory tokenURI
    ) external payable returns (uint256, address);

    function issueTicket(
        address _tokenAddress,
        string memory ticketName,
        string memory ticketSymbol,
        string memory ticketUri,
        address initialOwner,
        uint256 ticketAmount,
        uint256 ticketPrice
    ) external returns (address);

    function buyTicketByEther(
        address _ticketAddress,
        address adminAddress,
        uint256 ticketPrice
    ) external payable returns (uint256);

    function buyTicket(
        address ticketAddress
    ) external payable returns (uint256);
}
