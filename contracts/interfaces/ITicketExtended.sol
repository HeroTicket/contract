// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITicketExtended {
    event Minted(uint256 indexed tokenId, address indexed accountAddress);

    function mint(
        address to,
        string calldata tokenURI
    ) external payable returns (uint256, address);

    function executeCall(
        address ticketContractAddress,
        uint256 tokenId,
        address to
    ) external payable;

    function getNonce() external view returns (uint256);
}
