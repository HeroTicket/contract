// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ITicketExtended {
    event TBACreated(
        address indexed owner,
        address indexed account,
        uint256 tokenId
    );

    event TicketIssued(
        address indexed _ticketAddress,
        address indexed _owner,
        string _ticketName,
        string _ticketSymbol,
        string _ticketUri,
        address _initialOwner,
        uint256 _ticketAmount,
        uint256 _ticketPrice,
        uint _saleDuration
    );

    event TicketSold(
        address indexed _ticketAddress,
        address indexed _buyer,
        uint256 _ticketId
    );

    function createTBA(
        address to,
        string memory tokenURI
    ) external payable returns (uint256, address);

    function issueTicket(
        string memory ticketName,
        string memory ticketSymbol,
        string memory ticketUri,
        address issuer,
        uint256 ticketAmount,
        uint256 ticketPrice,
        uint saleDuration
    ) external returns (address);

    function buyTicketByEther(
        address _ticketAddress
    ) external payable returns (uint256);

    function buyTicketByToken(
        address ticketAddress,
        address buyer
    ) external payable returns (uint256);
}
