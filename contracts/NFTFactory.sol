// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFTFactory is ERC721URIStorage, Ownable {
    uint256 private _tokenIds;

    // Mapping to track transaction count for each address
    mapping(address => uint256) private _transactionCount;

    constructor() ERC721("Hero Ticket NFT", "HTN") Ownable(msg.sender) {}

    function mintNFT(
        address recipient,
        string memory tokenURI
    ) public onlyOwner returns (uint256) {
        _tokenIds = _tokenIds + 1;
        uint256 newItemId = _tokenIds;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        // Increment transaction count for the recipient address
        _transactionCount[recipient]++;

        return newItemId;
    }

    // Get transaction count for a specific address
    function getTransactionCount(
        address account
    ) public view returns (uint256) {
        return _transactionCount[account];
    }
}
