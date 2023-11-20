// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; // Counters 추가
import "./ERC6551Account.sol";

error NonexistentToken(uint256 _tokenId);
error NotOwner(uint256 _tokenId, address sender);
error AlreadyRegistered(string _ownerAddress, string _nftAddress);

// 보안 강화?

contract Ticket is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter; // Counters 사용
    Counters.Counter private _tokenIds; // _tokenIds를 Counters.Counter로 변경

    ERC6551Account private _ercAccount;

    constructor(
        string memory ticketName,
        string memory ticketSymbol,
        address initialOwner
    ) ERC721(ticketName, ticketSymbol) Ownable(initialOwner) {}

    // ticket이 구매확정 여부 저장(구매 후 신원인증을 진행 했는지)
    mapping(uint256 => bool) public _ticketSelled;

    // WhiteList 추가
    mapping(address => bool) public _whiteList;

    // Ticket mint
    function mintTicket(
        address _to,
        string calldata _tokenURI
    ) public onlyOwner returns (uint256) {
        require(_whiteList[_to], "recipient is not in white list");
        return _mintTicket(_to, _tokenURI);
    }

    // 구매자의 지갑(TBA)로 티켓 전송
    function transferTicket(uint256 _tokenId, address _buyer) public {
        require(!_ticketSelled[_tokenId], "Ticket is already selled");
        require(
            ownerOf(_tokenId) == msg.sender,
            "Not the owner of this ticket"
        );
        require(_whiteList[msg.sender], "Not White List Member");

        safeTransferFrom(msg.sender, _buyer, _tokenId);
    }

    function updateWhiteList(address to) public onlyOwner returns (bool) {
        if (_whiteList[to] == true) {
            return false;
        } else {
            _whiteList[to] = true;
            return true;
        }
    }

    function _mintTicket(
        address _to,
        string calldata _tokenURI
    ) internal virtual returns (uint256) {
        uint256 newTicketId = _tokenIds.current();
        _tokenIds.increment();
        _mint(_to, newTicketId);
        _setTokenURI(newTicketId, _tokenURI);
        return newTicketId;
    }
}
