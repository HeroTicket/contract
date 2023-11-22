// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITicketExtended {
    event Minted(uint256 indexed tokenId, address indexed accountAddress);

    function mint(
        address to,
        string calldata tokenURI
    ) external payable returns (uint256, address);

    function issueTicket(
        address _ticketExtendedAddress,
        address _tokenAddress,
        string memory ticketName,
        string memory ticketSymbol,
        string memory ticketUri,
        address initialOwner, // 관리자
        uint256 ticketAmount,
        uint256 ticketPrice
    ) external returns (address);
}
