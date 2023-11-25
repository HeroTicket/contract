// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITicketExtended {
    function mint(
        address to,
        string memory tokenURI
    ) external payable returns (uint256, address);

    function issueTicket(
        address _ticketExtendedAddress,
        address _tokenAddress,
        string memory ticketName,
        string memory ticketSymbol,
        string memory ticketUri,
        address initialOwner,
        uint256 ticketAmount,
        uint256 ticketPrice
    ) external returns (address);

    function buyTicket(
        address ticketAddress
    ) external payable returns (uint256);
}
