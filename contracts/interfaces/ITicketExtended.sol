// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ITicketExtended {
    event minted(uint256 tokenId);

    event TicketCreated(
        address indexed _ticketAddress,
        address indexed _owner,
        string _ticketName,
        string _ticketSymbol,
        string _ticketUri,
        address _initialOwner,
        uint256 _ticketAmount,
        uint256 _ticketPrice
    );

    event TicketSold(
        address indexed _ticketAddress,
        address indexed _buyer,
        uint256 _ticketId
    );

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
        address adminAddress
    ) external payable returns (uint256);

    function buyTicket(
        address ticketAddress
    ) external payable returns (uint256);
}
