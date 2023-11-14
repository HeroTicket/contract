// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Ticket.sol";
import "./ERC6551Account.sol";
import "./ERC6551Registry.sol";
import "../interfaces/IERC6551Account.sol";
import "./NFTFactory.sol";

contract TicketExtended is ERC721URIStorage {
    uint256 private _tokenId;

    ERC6551Registry private _registry;
    ERC6551Account private _account;
    NFTFactory private _nftFactory;

    event minted(uint256);

    // NFT Factory로 부터 NFT 생성 및 TBA 생성
    function mint(address to, string memory tokenURI) external payable {
        _tokenId++;
        _accountContract = new ERC6551Account();
        uint256 salt = generateRandomSalt();
        // TBA account 생성
        _accountAddress = _registry.createAccount(
            address(_accountContract),
            salt,
            block.chainid,
            address(_nftFactory),
            _tokenId
        );
        _expectAddress = _registry.account(
            address(_accountContract),
            salt,
            block.chainid,
            address(_nftFactory),
            _tokenId
        );
        require(_accountAddress == _expectAddress, "Account creation failed");

        _nftFactory.mintNFT(to, tokenURI);
        _nftFactory._setTokenURI(tokenId, _tokenURI);
        emit minted(_tokenId);
    }

    function generateRandomSalt() internal view returns (uint256) {
        bytes32 hash = keccak256(
            abi.encodePacked(block.timestamp, msg.sender, nonce())
        );
        return uint256(hash);
    }
}
