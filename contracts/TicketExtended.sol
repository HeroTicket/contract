// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC6551Account.sol";
import "./ERC6551Registry.sol";
import "./NFTFactory.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ITicketExtended.sol";

// error 정의

contract TicketExtended is
    ERC721URIStorage,
    Ownable(msg.sender),
    ITicketExtended
{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    ERC6551Registry private _registry;
    ERC6551Account private _account;
    NFTFactory private _nftFactory;

    constructor() ERC721("Hero Ticket", "HT") {
        _nftFactory = new NFTFactory();
        _account = new ERC6551Account();
        _registry = new ERC6551Registry();
    }

    event minted(uint256 tokenId);

    // NFT Factory로 부터 Hero Ticket NFT 생성 및 TBA 생성
    function mint(
        address to,
        string memory tokenURI
    ) external payable returns (uint256, address) {
        uint256 tokenId = _tokenIds.current();
        _tokenIds.increment();

        uint256 salt = generateRandomSalt();

        // TBA account 생성
        address accountAddress = _registry.createAccount(
            address(_account),
            bytes32(salt),
            block.chainid,
            address(_nftFactory),
            tokenId
        );

        address expectAddress = _registry.account(
            address(_account),
            bytes32(salt),
            block.chainid,
            address(_nftFactory),
            tokenId
        );

        require(accountAddress == expectAddress, "Account creation failed");

        uint256 newNFTId = _nftFactory.mintNFT(to, tokenURI);

        emit minted(tokenId);
        return (newNFTId, accountAddress);
    }

    function executeCall(
        address ticketContractAddress,
        uint256 tokenId,
        address to
    ) public onlyOwner {
        _account.execute(ticketContractAddress, tokenId, to);
    }

    function getNonce() public view returns (uint256) {
        return _nftFactory.getTransactionCount(msg.sender);
    }

    function generateRandomSalt() internal view returns (uint256) {
        bytes32 hash = keccak256(
            abi.encodePacked(block.timestamp, msg.sender, getNonce())
        );
        return uint256(hash);
    }
}
