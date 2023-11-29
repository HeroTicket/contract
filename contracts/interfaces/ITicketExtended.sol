// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ITicketExtended {
    enum TicketSaleType {
        ETHER,
        TOKEN
    }

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
        uint256 _ticketEthPrice,
        uint256 _ticketTokenPrice,
        uint _saleDuration
    );

    event TicketSold(
        address indexed _ticketAddress,
        address indexed _buyer,
        uint256 _ticketId,
        TicketSaleType _saleType
    );

    event TokenReward(address to, uint256 amount);

    event TokenPaymentForIssueTicket(
        address indexed _issuer,
        uint256 _ticketTokenPrice
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
        uint256 ticketEthPrice,
        uint256 ticketTokenPrice,
        uint saleDuration
    ) external returns (address);

    function buyTicketByEther(
        address _ticketAddress
    ) external payable returns (uint256);

    function buyTicketByToken(
        address ticketAddress,
        address buyer
    ) external returns (uint256);
}
