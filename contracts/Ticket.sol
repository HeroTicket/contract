// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./ERC6551Account.sol";
import "./TicketExtended.sol";
import "./HeroToken.sol";
import "./interfaces/ITicket.sol";

contract Ticket is Ownable(msg.sender), ITicket, ERC721URIStorage {
    HeroToken private _token;

    uint public constant MIN_TICKET_SUPPLY = 1;
    uint public constant MIN_TICKET_PRICE = 1 wei;
    uint public constant MIN_TICKET_SALE_DURATION = 1 days;

    uint256 private _tokenIds;
    string private baseTokenURI;

    address public issuerAddress;
    uint256 public remainTicketAmount;
    uint256 public ticketPrice;
    uint public ticketSaleStartAt;
    uint public ticketSaleEndAt;

    // WhiteList(신원 인증완료된 사람)
    mapping(address => bool) public whiteList;
    // 티켓 구매 여부 (중복 구매 x)
    mapping(address => bool) public hasTicket;

    constructor(
        address _tokenAddress,
        string memory ticketName,
        string memory ticketSymbol,
        string memory ticketUri,
        address _issuerAddress,
        uint256 ticketAmount,
        uint256 _ticketPrice,
        uint ticketSaleDuration
    ) ERC721(ticketName, ticketSymbol) {
        require(
            ticketAmount >= MIN_TICKET_SUPPLY,
            "initial ticket supply should be greater than or equal to 1"
        );
        require(
            _ticketPrice >= MIN_TICKET_PRICE,
            "ticket price should be greater than or equal to 1 wei"
        );
        require(
            ticketSaleDuration >= MIN_TICKET_SALE_DURATION,
            "ticket sale duration should be greater than or equal to 1 day"
        );
        require(_tokenAddress != address(0x00), "invalid token address");
        require(_issuerAddress != address(0x00), "invalid issuer address");

        _token = HeroToken(_tokenAddress);
        remainTicketAmount = ticketAmount;
        issuerAddress = _issuerAddress;
        ticketPrice = _ticketPrice;
        baseTokenURI = ticketUri;
        ticketSaleStartAt = block.timestamp;
        ticketSaleEndAt = block.timestamp + ticketSaleDuration;
    }

    // 티켓 mint(ether로 ticket구매 시 사용)
    function buyTicketWithEther(
        address buyer
    ) external payable onlyOwner returns (uint256) {
        require(remainTicketAmount > 0, "No more ticket"); // 티켓 수량 검사
        require(block.timestamp < ticketSaleEndAt, "ticket sales are closed"); // 티켓 판매 종료 시점 검사
        require(buyer != address(0x00), "invalid address"); // buyer 주소 검사
        require(whiteList[buyer], "recipient is not in white list"); // whiltelist 검사
        require(!hasTicket[buyer], "already has ticekt"); // 티켓 구매 여부 검사
        require(msg.value == ticketPrice, "invalid ticket price");

        // 티켓 수량 감소
        remainTicketAmount -= 1;

        uint256 newTicketId = _mintTicket(buyer, baseTokenURI);

        emit TicketSold(buyer, newTicketId, baseTokenURI);

        return newTicketId;
    }

    // token으로 티켓구매
    function buyTicketWithToken(
        address buyer
    ) external onlyOwner returns (uint256) {
        require(remainTicketAmount > 0, "No more ticket"); // 티켓 수량 검사
        require(block.timestamp < ticketSaleEndAt, "ticket sales are closed"); // 티켓 판매 종료 시점 검사
        require(buyer != address(0x00), "invalid address"); // buyer 주소 검사
        require(!hasTicket[buyer], "already has ticekt"); // 티켓 구매 여부 검사

        // 티켓결제
        withdrawToken(buyer);

        // 티켓 수량 감소
        remainTicketAmount -= 1;

        uint256 newTicketId = _mintTicket(buyer, baseTokenURI);

        emit TicketSold(buyer, newTicketId, baseTokenURI);

        return newTicketId;
    }

    // 구매자의 지갑(TBA)로 티켓 전송
    function transferTicket(uint256 _tokenId, address _buyer) public {
        require(
            ownerOf(_tokenId) == msg.sender,
            "Not the owner of this ticket"
        );

        safeTransferFrom(msg.sender, _buyer, _tokenId);

        emit TicketTransferred(_tokenId, msg.sender, _buyer);
    }

    // 티켓 발행자에게 결제 대금 정산
    function claimPayment() external {
        require(
            block.timestamp >= ticketSaleEndAt,
            "ticket sale is not finished"
        );

        // send eth
        // TODO: calculate fee
        uint ethAmount = address(this).balance;
        if (ethAmount > 0) {
            (bool ok, ) = issuerAddress.call{value: ethAmount}("");
            if (!ok) {
                revert();
            }
        }

        // send token
        // TODO: calculate fee
        uint tokenAmount = _token.balanceOf(address(this));
        if (tokenAmount > 0) {
            bool ok = _token.transfer(issuerAddress, tokenAmount);
            if (!ok) {
                revert();
            }
        }

        if (ethAmount > 0 || tokenAmount > 0) {
            emit PaymentClaimed(issuerAddress, ethAmount, tokenAmount);
        }
    }

    function updateWhiteList(address to, bool allow) external onlyOwner {
        whiteList[to] = allow;

        emit WhiteListUpdated(to, allow);
    }

    // 토큰 결제 대금 인출하는 함수
    function withdrawToken(address sender) internal {
        uint256 senderBalance = _token.balanceOf(sender);
        if (senderBalance < ticketPrice) {
            revert("Insufficient balance");
        }

        uint256 senderAllowance = _token.allowance(sender, address(this));
        if (senderAllowance < ticketPrice) {
            revert("Insufficient allowance");
        }

        // TransferFrom
        bool ok = _token.transferFrom(sender, address(this), ticketPrice);
        if (!ok) {
            revert("transfer failed");
        }
    }

    function _mintTicket(
        address _to,
        string storage _tokenURI
    ) internal returns (uint256) {
        _tokenIds += 1;
        uint256 newTicketId = _tokenIds;
        _mint(_to, newTicketId);
        _setTokenURI(newTicketId, _tokenURI);
        return newTicketId;
    }
}
