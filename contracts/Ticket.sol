// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

error NonexistentToken(uint256 _tokenId);
error NotOwner(uint256 _tokenId, address sender);
error AlreadyRegistered(string _ownerAddress, string _nftAddress);

contract Ticket is ERC721URIStorage, Ownable {
    uint256 private _tokenIds;

    constructor(
        string ticketName,
        string ticketSymbol
    ) ERC721(ticketName, ticketSymbol) {}

    // ticketData 저장
    mapping(uint256 => string) public _ticketURI;

    // ticket이 구매확정 여부 저장(구매 후 신원인증을 진행 했는지)
    mapping(uint256 => bool) public _ticketSelled;

    // address별 TBA 저장
    // owner address => nft address => TBA address
    mapping(address => mapping(address => address)) public _ownerTBA;

    // ticket Name 확인
    function ticketName(uint256 _tokenId) public view returns (string memory) {
        return _ticketData[_tokenId].name;
    }

    // ticket 구매확정 여부 확인
    function isTicketSelled(uint256 _tokenId) public view returns (bool) {
        return _ticketSelled[_tokenId];
    }

    // ticket 구매자 주소 확인
    function ticketOwner(uint256 _tokenId) public view returns (address) {
        return ownerOf(_tokenId);
    }

    // ticket 구매자가 맞는지 확인
    function isTicketOwner(uint256 _tokenId) public view returns (bool) {
        return ownerOf(_tokenId) == msg.sender;
    }

    // owner address => nft address => TBA address 등록
    function updateTBA(
        string calldata _ownerAddress,
        string calldata _nftAddress,
        string calldata _tbaAddress
    ) public onlyOwner {
        if (_ownerTBA[_ownerAddress][_nftAddress] != address(0)) {
            revert AlreadyRegistered(_ownerAddress, _nftAddress);
        }
        _ownerTBA[_ownerAddress][_nftAddress] = _tbaAddress;
    }

    // onwer의 TBA 확인
    function ownerTBA(
        address _owner,
        address _nftAddress
    ) public view returns (address) {
        return _ownerTBA[_owner][_nftAddress];
    }

    // Ticket mint
    function mintTicket(
        address _to,
        string calldata _tokenURI
    ) public onlyOwner returns (uint256) {
        return _mintTicket(_to, _tokenURI);
    }

    // 구매자의 지갑(TBA)로 티켓 전송
    function transferTicket(uint256 _tokenId, string calldata _address) public {
        require(!isTicketSelled(_tokenId), "Ticket is already selled");
        if (ownerof(_tokenId) != msg.sender) {
            revert NotOwner(_tokenId, msg.sender);
        }
        _transfer(msg.sender, _ticketBuyer[_tokenId], _tokenId);
    }

    function _mintTicket(
        address _to,
        string calldata _tokenURI
    ) internal virtual returns (uint256) {
        uint256 newTicketId = _tokenIds.current();
        _tokenIds += 1;
        _mint(_to, newTicketId);
        _setTokenURI(newTicketId, _tokenURI);
        ticketSelled[newTicketId] = false;
        return newTicketId;
    }
}
