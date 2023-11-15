// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./ERC6551Account.sol";

error NonexistentToken(uint256 _tokenId);
error NotOwner(uint256 _tokenId, address sender);
error AlreadyRegistered(string _ownerAddress, string _nftAddress);

contract Ticket is ERC721URIStorage, Ownable {
    uint256 private _ticketIds;

    ERC6551Account private _ercAccount;

    constructor(
        string ticketName,
        string ticketSymbol
    ) ERC721(ticketName, ticketSymbol) {}

    // ticketData 저장
    mapping(uint256 => string) public _ticketURI;

    // ticket이 구매확정 여부 저장(구매 후 신원인증을 진행 했는지)
    mapping(uint256 => bool) public _ticketSelled;

    // 소유자의 티켓 List 저장
    mapping(address => uint256[]) public _ticketList;

    // ticket Name 확인
    function ticketName(uint256 _ticketId) public view returns (string memory) {
        return _ticketData[_ticketId].name;
    }

    // ticket 구매확정 여부 확인
    function isTicketSelled(uint256 _ticketId) public view returns (bool) {
        return _ticketSelled[_ticketId];
    }

    // ticket 구매자 주소 확인
    function ticketOwner(uint256 _ticketId) public view returns (address) {
        return ownerOf(_ticketId);
    }

    // ticket 구매자가 맞는지 확인
    function isTicketOwner(uint256 _ticketId) public view returns (bool) {
        return ownerOf(_ticketId) == msg.sender;
    }

    // onwer의 확인
    function ownerTBA(
        address _owner,
        address _nftAddress
    ) public view returns (address) {
        return _ercAccount._ownerTBA[_owner][_nftAddress];
    }

    // 보유중인 티켓확인
    function myTicketList() public view returns (uint256[] memory) {
        return _ticketList[msg.sender];
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

    // TBA안에 있는 NFT List가져오기
    // _ticketURI에서

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
