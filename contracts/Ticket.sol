// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/Counters.sol";

contract Ticket is ERC721, Ownable, Counters {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor(
        string ticketName,
        string ticketSymbol
    ) ERC721(ticketName, ticketSymbol) {}

    // ticketData 저장
    mapping(uint256 => ticketData) public _ticketData;
    // ticket이 구매확정 여부 저장
    mapping(uint256 => bool) public _ticketSelled;
    // ticket 구매 확정 시 구매자 주소 저장
    mapping(uint256 => address) public _ticketBuyer;

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
}
