// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./ERC6551Account.sol";
import "./HeroToken.sol";
import "./interfaces/ITicket.sol";

error InvalidAddress();
error InvalidTicketAmount();
error InvalidTicketPrice();
error InvalidTicketSaleDuration();
error InsuffientTicketAmount();
error TicketSalePeriodEnded();
error NotAllowedToBuyTicket(address blockedAddress);
error AlreadyHasTicket(address buyer);
error InvalidEthAmount(uint256 ethAmount);
error NotOwnerOfTicket(uint256 _tokenId, address sender);
error SalePeriodNotEnded();
error InvalidTokenAmount(uint256 tokenAmount);
error InvalidTokenAllowance(uint256 tokenAllowance);
error TransferFailed(address from, address to, uint256 amount);

contract Ticket is Ownable(msg.sender), ITicket, ERC721URIStorage {
    HeroToken private _token; // HeroToken 컨트랙트 주소

    uint public constant MIN_TICKET_SUPPLY = 1; // 최소 티켓 발행 수량
    uint public constant MIN_TICKET_ETH_PRICE = 1 gwei; // 최소 티켓 결제 금액(ether)
    uint public constant MIN_TICKET_TOKEN_PRICE = 1; // 최소 티켓 결제 금액(token)
    uint public constant MIN_TICKET_SALE_DURATION = 1 days; // 최소 티켓 판매 기간

    uint256 private _tokenIds; // 티켓 아이디
    string private baseTokenURI; // 티켓 URI

    address public issuerAddress; // 티켓 발행자 주소
    uint256 public remainTicketAmount; // 남은 티켓 수량
    uint256 public ticketEthPrice; // 티켓 결제 금액(ether)
    uint256 public ticketTokenPrice; // 티켓 결제 금액(token)

    uint public ticketSaleStartAt; // 티켓 판매 시작 시점
    uint public ticketSaleEndAt; // 티켓 판매 종료 시점

    uint256 public ticketSaleEthIncome; // 티켓 이더 판매 수익
    uint256 public ticketSaleTokenIncome; // 티켓 토큰 판매 수익

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
        uint256 _ticketEthPrice,
        uint256 _ticketTokenPrice,
        uint ticketSaleDuration
    ) ERC721(ticketName, ticketSymbol) {
        if (_tokenAddress == address(0x00)) revert InvalidAddress(); // token 주소 검사
        if (_issuerAddress == address(0x00)) revert InvalidAddress(); // issuer 주소 검사
        if (ticketAmount < MIN_TICKET_SUPPLY) revert InvalidTicketAmount(); // 티켓 발행 수량 검사
        if (_ticketEthPrice < MIN_TICKET_ETH_PRICE) revert InvalidTicketPrice(); // 티켓 결제 금액(ether) 검사
        if (_ticketTokenPrice < MIN_TICKET_TOKEN_PRICE)
            revert InvalidTicketPrice(); // 티켓 결제 금액(token) 검사
        if (ticketSaleDuration < MIN_TICKET_SALE_DURATION)
            revert InvalidTicketSaleDuration(); // 티켓 판매 기간 검사

        _token = HeroToken(_tokenAddress);
        remainTicketAmount = ticketAmount;
        issuerAddress = _issuerAddress;
        ticketEthPrice = _ticketEthPrice;
        ticketTokenPrice = _ticketTokenPrice;
        baseTokenURI = ticketUri;
        ticketSaleStartAt = block.timestamp;
        ticketSaleEndAt = block.timestamp + ticketSaleDuration;
    }

    // 티켓 mint(ether로 ticket구매 시 사용)
    function buyTicketByEther(
        address buyer
    ) external payable onlyOwner returns (uint256) {
        if (remainTicketAmount == 0) revert InsuffientTicketAmount(); // 티켓 수량 검사
        if (block.timestamp >= ticketSaleEndAt) revert TicketSalePeriodEnded(); // 티켓 판매 종료 시점 검사
        if (buyer == address(0x00)) revert InvalidAddress(); // buyer 주소 검사
        if (!whiteList[buyer]) revert NotAllowedToBuyTicket(buyer); // whiltelist 검사
        if (hasTicket[buyer]) revert AlreadyHasTicket(buyer); // 티켓 구매 여부 검사
        if (msg.value != ticketEthPrice) revert InvalidEthAmount(msg.value); // 티켓 결제 금액 검사

        // 티켓 구매 확정
        hasTicket[buyer] = true;

        // 티켓 수량 감소
        remainTicketAmount -= 1;

        // 티켓 판매 수익 증가
        ticketSaleEthIncome += ticketEthPrice;

        uint256 newTicketId = _mintTicket(buyer, baseTokenURI); // 티켓 발행

        emit TicketSold(buyer, newTicketId, baseTokenURI); // 이벤트 발생

        return newTicketId; // 티켓 아이디 반환
    }

    // token으로 티켓구매
    function buyTicketByToken(
        address buyer
    ) external onlyOwner returns (uint256) {
        if (remainTicketAmount == 0) revert InsuffientTicketAmount(); // 티켓 수량 검사
        if (block.timestamp >= ticketSaleEndAt) revert TicketSalePeriodEnded(); // 티켓 판매 종료 시점 검사
        if (buyer == address(0x00)) revert InvalidAddress(); // buyer 주소 검사
        if (hasTicket[buyer]) revert AlreadyHasTicket(buyer); // 티켓 구매 여부 검사

        // 티켓결제
        withdrawToken(buyer);

        // 티켓 구매 확정
        hasTicket[buyer] = true;

        // 티켓 수량 감소
        remainTicketAmount -= 1;

        // 티켓 판매 수익 증가
        ticketSaleTokenIncome += ticketTokenPrice;

        uint256 newTicketId = _mintTicket(buyer, baseTokenURI); // 티켓 발행

        emit TicketSold(buyer, newTicketId, baseTokenURI); // 이벤트 발생

        return newTicketId; // 티켓 아이디 반환
    }

    // 구매자의 지갑(TBA)로 티켓 전송
    function transferTicket(uint256 _tokenId, address _buyer) public {
        if (_buyer == address(0x00)) revert InvalidAddress(); // buyer 주소 검사
        if (!(ownerOf(_tokenId) == msg.sender))
            revert NotOwnerOfTicket(_tokenId, msg.sender); // 티켓 소유자 검사

        safeTransferFrom(msg.sender, _buyer, _tokenId);
        emit TicketTransferred(_tokenId, msg.sender, _buyer);
    }

    // 티켓 발행자에게 결제 대금 정산
    function claimSettlement() external {
        if (block.timestamp < ticketSaleEndAt) revert SalePeriodNotEnded(); // 티켓 판매 종료 시점 검사

        // 이더 정산
        uint ethAmount = ticketSaleEthIncome;
        if (ethAmount > 0) {
            ticketSaleEthIncome = 0; // 티켓 판매 수익 초기화

            // TODO: calculate fee

            (bool ok, ) = issuerAddress.call{value: ethAmount}(""); // 이더 정산
            if (!ok) {
                revert();
            }
        }

        // send token
        uint tokenAmount = ticketSaleTokenIncome;
        if (tokenAmount > 0) {
            ticketSaleTokenIncome = 0; // 티켓 판매 수익 초기화

            // TODO: calculate fee

            bool ok = _token.transfer(issuerAddress, tokenAmount); // 토큰 정산
            if (!ok) {
                revert();
            }
        }

        if (ethAmount > 0 || tokenAmount > 0) {
            emit SettlementClaimed(issuerAddress, ethAmount, tokenAmount); // 이벤트 발생
        }
    }

    // 화이트리스트 업데이트
    function updateWhiteList(address to, bool allow) external onlyOwner {
        if (to == address(0x00)) revert InvalidAddress(); // to 주소 검사

        whiteList[to] = allow; // 화이트리스트 업데이트

        emit WhiteListUpdated(to, allow);
    }

    // 토큰 결제 대금 인출하는 함수
    function withdrawToken(address sender) internal {
        uint256 senderBalance = _token.balanceOf(sender); // sender의 토큰 잔액
        if (senderBalance < ticketTokenPrice)
            revert InvalidTokenAmount(senderBalance); // 토큰 잔액 검사

        uint256 senderAllowance = _token.allowance(sender, address(this)); // sender의 토큰 허용량
        if (senderAllowance < ticketTokenPrice)
            revert InvalidTokenAllowance(senderAllowance); // 토큰 허용량 검사

        // 토큰 결제
        bool ok = _token.transferFrom(sender, address(this), ticketTokenPrice);
        if (!ok) revert TransferFailed(sender, address(this), ticketTokenPrice); // 토큰 결제 실패 검사
    }

    // 티켓 발행
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
