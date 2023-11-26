// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./ERC6551Account.sol";
import "./TicketExtended.sol";
import "./HeroToken.sol";
import "./interfaces/ITicket.sol";

error NonexistentToken(uint256 _tokenId);
error NotOwner(uint256 _tokenId, address sender);
error AlreadyRegistered(string _ownerAddress, string _nftAddress);
error InSufficientBalance(
    address _sender,
    uint256 _senderBalance,
    uint256 _amount
);
error PaymentFailed(address _sender, address _recipient, uint256 _amount);

contract Ticket is Ownable(msg.sender), ITicket, ERC721URIStorage {
    uint256 private _tokenIds;

    ERC6551Account private _ercAccount;

    TicketExtended private _ticketExtended;

    HeroToken private _token;

    uint256 remainTicketAmount;

    address adminAddress;

    uint256 ticketPrice;

    string baseTokenURI;

    constructor(
        address _ticketExtendedAddress,
        address _tokenAddress,
        string memory ticketName,
        string memory ticketSymbol,
        string memory ticketUri,
        address initialOwner,
        uint256 ticketAmount,
        uint256 _ticketPrice
    ) ERC721(ticketName, ticketSymbol) {
        _ticketExtended = TicketExtended(_ticketExtendedAddress);
        _token = HeroToken(_tokenAddress);
        remainTicketAmount = ticketAmount;
        adminAddress = initialOwner;
        ticketPrice = _ticketPrice;
        baseTokenURI = ticketUri;
    }

    // WhiteList(신원 인증완료된 사람)
    mapping(address => bool) public _whiteList;

    // 티켓 mint(ether로 ticket구매 시 사용)
    function mintTicket(address buyer) external onlyOwner returns (uint256) {
        require(remainTicketAmount > 0, "No more ticket");
        require(_whiteList[buyer], "recipient is not in white list");

        address tbaAddress = _ticketExtended._tbaAddress(buyer);

        require(tbaAddress != address(0x00), "");

        // 티켓 수량 감소
        remainTicketAmount = remainTicketAmount - 1;

        // ticketExtended에 _ticketAddresses[tbaAddress]에 구매할 티켓 컨트랙트 주소 추가
        _ticketExtended.updateTicketAddresses(buyer, address(this));
        uint256 newTicketId = _mintTicket(tbaAddress, baseTokenURI);
        emit TicketBuy(buyer, newTicketId, baseTokenURI);
        return newTicketId;
    }

    // token으로 티켓구매
    function buyTicket(
        address buyer
    ) external payable onlyOwner returns (uint256) {
        require(remainTicketAmount > 0, "No more ticket");
        require(_whiteList[buyer], "recipient is not in white list");

        address tbaAddress = _ticketExtended._tbaAddress(buyer);

        require(tbaAddress != address(0x00), "");

        // 티켓결제
        withdraw(buyer, adminAddress, ticketPrice);

        // 티켓 수량 감소
        remainTicketAmount = remainTicketAmount - 1;

        // ticketExtended에 _ticketAddresses[tbaAddress]에 구매할 티켓 컨트랙트 주소 추가
        _ticketExtended.updateTicketAddresses(buyer, address(this));
        uint256 newTicketId = _mintTicket(tbaAddress, baseTokenURI);
        emit TicketBuy(buyer, newTicketId, baseTokenURI);
        return newTicketId;
    }

    // 구매자의 지갑(TBA)로 티켓 전송
    function transferTicket(uint256 _tokenId, address _buyer) public {
        require(
            ownerOf(_tokenId) == msg.sender,
            "Not the owner of this ticket"
        );
        require(_whiteList[msg.sender], "Not White List Member");

        safeTransferFrom(msg.sender, _buyer, _tokenId);
        emit TicketTransferred(_tokenId, msg.sender, _buyer);
    }

    function updateWhiteList(address to) external returns (bool) {
        if (_whiteList[to] == true) {
            return false;
        } else {
            _whiteList[to] = true;
            emit WhiteListUpdated(to);
            return true;
        }
    }

    // 결제 대금 인출하는 함수
    function withdraw(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(recipient == adminAddress, "recipient is not admin");

        uint256 senderBalance = _token.balanceOf(sender);
        if (senderBalance < amount) {
            revert("Insufficient balance");
        }

        // approve된 금액 확인, 만약 amount보다 작다면 그만큼 approve
        // uint256 allowance = _token.allowance(sender, recipient);
        // if (allowance < amount) {
        //     _token.approve(recipient, amount);
        // }

        // TransferFrom
        _token.transferFrom(sender, recipient, amount);
    }

    function isAddressInWhiteList(
        address recipient
    ) external view returns (bool) {
        return _whiteList[recipient];
    }

    function _mintTicket(
        address _to,
        string storage _tokenURI
    ) internal returns (uint256) {
        uint256 newTicketId = _tokenIds;
        _tokenIds++;
        _mint(_to, newTicketId);
        _setTokenURI(newTicketId, _tokenURI);
        return newTicketId;
    }
}
