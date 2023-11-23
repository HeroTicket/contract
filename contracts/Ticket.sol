// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol"; // Counters 추가
import "./ERC6551Account.sol";
import "./interfaces/ITicketExtended.sol";
import "./interfaces/ITicket.sol";
import "./interfaces/IToken.sol";

error NonexistentToken(uint256 _tokenId);
error NotOwner(uint256 _tokenId, address sender);
error AlreadyRegistered(string _ownerAddress, string _nftAddress);
error InSufficientBalance(
    address _sender,
    uint256 _senderBalance,
    uint256 _amount
);
error PaymentFailed(address _sender, address _recipient, uint256 _amount);

contract Ticket is ERC721, Ownable, ITicket, ERC721URIStorage {
    using Counters for Counters.Counter; // Counters 사용
    Counters.Counter private _tokenIds; // _tokenIds를 Counters.Counter로 변경

    ERC6551Account private _ercAccount;

    ITicketExtended private _ticketExtended;

    uint256 remainTicketAmount;

    address adminAddress;

    constructor(
        address _ticketExtendedAddress,
        address _tokenAddress,
        string memory ticketName,
        string memory ticketSymbol,
        string memory ticketUri,
        address initialOwner, // 관리자
        uint256 ticketAmount,
        uint256 ticketPrice
    ) ERC721(ticketName, ticketSymbol) Ownable(initialOwner) {
        _ticketExtended = ITicketExtended(_ticketExtededAddress);
        _token = IToken(_tokenAddress);
        remainTicketAmount = ticketAmount;
        adminAddress = initialOwner;
    }

    // WhiteList(신원 인증완료된 사람)
    mapping(address => bool) public _whiteList;

    // function mintTicket(
    //     address _to,
    //     string calldata _tokenURI
    // ) public payable onlyOwner returns (uint256) {
    //     require(remainTicketAmount > 0, "No more ticket");
    //     require(_whiteList[_to], "recipient is not in white list");

    //     address tbaAddress = _ticketExtended._tbaAddress[_to];

    //     requre(!tbaAddress != address(0x00), "");

    //     // 결제 금액 확인

    //     // ERC20 approve된 금액 확인
    //     // TransferFrom

    //     remainTicketAmount = remainTicketAmount - 1;
    //     return _mintTicket(tbaAddress, _tokenURI);
    // }

    function buyTicket(
        string calldata _tokenURI
    ) external payable returns (uint256) {
        require(remainTicketAmount > 0, "No more ticket");
        require(_whiteList[msg.sender], "recipient is not in white list");

        address tbaAddress = _ticketExtended._tbaAddress[msg.sender];

        require(!tbaAddress != address(0x00), "");

        // 티켓결제
        bool result = withdraw(msg.sender, adminAddress, ticketPrice);
        if (!result) {
            revert(msg.sender, adminAddress, ticketPrice);
        }

        // 티켓 수량 감소
        remainTicketAmount = remainTicketAmount - 1;

        // ticketExtended에 _ticketAddresses[tbaAddress]에 구매할 티켓 컨트랙트 주소 추가
        _ticketExtended._ticketAddresses[tbaAddress].push(address(this));
        return _mintTicket(tbaAddress, _tokenURI);
    }

    // 구매자의 지갑(TBA)로 티켓 전송
    function transferTicket(uint256 _tokenId, address _buyer) public {
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

    // 결제 대금 인출하는 함수
    function withdraw(
        address sender,
        address recipient,
        uint256 amount
    ) internal payable returns (bool) {
        require(_whiteList[sender], "Not White List Member");
        require(recipient == adminAddress, "recipient is not admin");

        uint256 senderBalance = _token.balanceOf(sender);
        if (senderBalance < amount) {
            revert(sender, senderBalance, amount);
        }

        // approve된 금액 확인, 만약 amount보다 작다면 그만큼 approve
        uint245 allowance = _token.allowance(sender, recipient);
        if (allowance < amount) {
            _token.approve(recipient, amount);
        }

        // TransferFrom
        _token.transferFrom(sender, recipient, amount);
        return true;
    }

    function _mintTicket(address _to) internal virtual returns (uint256) {
        uint256 newTicketId = _tokenIds.current();
        _tokenIds.increment();
        _mint(_to, newTicketId);
        _setTokenURI(newTicketId, _tokenURI);
        return newTicketId;
    }
}
