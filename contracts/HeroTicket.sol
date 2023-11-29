// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./interfaces/ITicketExtended.sol";
import "./ERC6551Account.sol";
import "./ERC6551Registry.sol";
import "./NFTFactory.sol";
import "./HeroToken.sol";
import "./Ticket.sol";

error TBAAlreadyExists();
error TicketNotIssuedByHeroTicket();
error InvalidPaymentAmount();

contract HeroTicket is Ownable(msg.sender), ITicketExtended {
    ERC6551Registry private _registry;
    ERC6551Account private _account;
    NFTFactory private _nftFactory;
    HeroToken private _heroToken;

    // tbaAddress mapping 추가
    mapping(address => address) public tbaAddress;
    // 티켓 주소 배열(소유자 주소 => 보유중인 티켓 컨트랙트 주소 배열)
    mapping(address => address[]) public ownedTickets;

    mapping(address => bool) public issuedTicket;

    address[] public _tickets;

    constructor(address payable accountImpl, address registryImpl) {
        _nftFactory = new NFTFactory();
        _heroToken = new HeroToken("HeroToken", "HT");
        _account = ERC6551Account(accountImpl);
        _registry = ERC6551Registry(registryImpl);
    }

    // NFT Factory로 부터 Hero Ticket NFT 생성 및 TBA 생성
    function createTBA(
        address to,
        string memory tokenURI
    ) external payable onlyOwner returns (uint256, address) {
        if (tbaAddress[to] != address(0x00)) revert TBAAlreadyExists();

        uint256 tokenId = _nftFactory.mintNFT(to, tokenURI);

        uint256 salt = generateRandomSalt(tokenId);

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

        tbaAddress[to] = accountAddress;

        // 토큰 보상 지급
        _tokenReward(accountAddress, 1000);

        emit TBACreated(to, accountAddress, tokenId);

        return (tokenId, accountAddress);
    }

    // 티켓 ai 이미지 생성 함수
    // requestId 반환

    // 프론트에서 이미지가 생성이 되었는지 확인을 하고
    // issueTicket으로 requestId를 넘겨줌
    // issueTicket에서 requestId를 사용해서 이미지 string을 찾아서 ticketUri로 넘겨줌

    // emit event
    function issueTicket(
        string memory ticketName,
        string memory ticketSymbol,
        string memory ticketUri,
        address issuer,
        uint256 ticketAmount,
        uint256 ticketEthPrice,
        uint256 ticketTokenPrice,
        uint saleDuration
    ) external onlyOwner returns (address) {
        // issuer tba로부터 토큰 차감
        _tokenPaymentForIssueTicket(issuer, ticketTokenPrice);

        Ticket _ticket = new Ticket(
            address(_heroToken),
            ticketName,
            ticketSymbol,
            ticketUri,
            issuer,
            ticketAmount,
            ticketEthPrice,
            ticketTokenPrice,
            saleDuration
        );

        address ticketAddress = address(_ticket);

        issuedTicket[ticketAddress] = true;
        _tickets.push(ticketAddress);

        emit TicketIssued(
            ticketAddress,
            address(this),
            ticketName,
            ticketSymbol,
            ticketUri,
            issuer,
            ticketAmount,
            ticketEthPrice,
            ticketTokenPrice,
            saleDuration
        );

        return ticketAddress;
    }

    // ether로 티켓 구매
    function buyTicketByEther(
        address _ticketAddress
    ) external payable returns (uint256) {
        if (!issuedTicket[_ticketAddress]) revert TicketNotIssuedByHeroTicket();

        Ticket _ticket = Ticket(_ticketAddress);

        uint256 ticketPrice = _ticket.ticketEthPrice();

        if (msg.value != ticketPrice) revert InvalidPaymentAmount();

        uint256 newTicketId = _ticket.buyTicketByEther{value: ticketPrice}(
            tbaAddress[msg.sender]
        );

        // TODO: 토큰 보상 지급
        _tokenReward(tbaAddress[msg.sender], 1000);

        _ticket.approve(msg.sender, newTicketId);

        emit TicketSold(
            _ticketAddress,
            msg.sender,
            newTicketId,
            TicketSaleType.ETHER
        );

        return newTicketId;
    }

    // token으로 티켓 구매
    function buyTicketByToken(
        address _ticketAddress,
        address _buyer
    ) external onlyOwner returns (uint256) {
        if (!issuedTicket[_ticketAddress]) revert TicketNotIssuedByHeroTicket();
        if (_buyer == address(0x00)) revert InvalidAddress();

        address buyerAccount = tbaAddress[_buyer];
        if (buyerAccount == address(0x00)) revert InvalidAddress();

        Ticket _ticket = Ticket(_ticketAddress);

        uint256 ticketPrice = _ticket.ticketTokenPrice();

        // approve from buyer or buyerAccount
        uint256 buyerBalance = _heroToken.balanceOf(_buyer);
        uint256 accountBalance = _heroToken.balanceOf(buyerAccount);

        if (buyerBalance + accountBalance < ticketPrice)
            revert InvalidPaymentAmount();

        if (accountBalance < ticketPrice) {
            // transfer from buyer to buyerAccount
            uint256 shortage = ticketPrice - accountBalance;
            _heroToken.transferFromForPayment(_buyer, buyerAccount, shortage);
        }

        // approve from account to ticket contract
        _heroToken.approveForPayment(buyerAccount, _ticketAddress, ticketPrice);

        uint256 newTicketId = _ticket.buyTicketByToken(buyerAccount);

        emit TicketSold(
            _ticketAddress,
            _buyer,
            newTicketId,
            TicketSaleType.TOKEN
        );

        return newTicketId;
    }

    function updateWhiteList(
        address _ticketAddress,
        address to
    ) external onlyOwner {
        if (!issuedTicket[_ticketAddress]) revert TicketNotIssuedByHeroTicket();
        if (to == address(0x00)) revert InvalidAddress();

        Ticket _ticket = Ticket(_ticketAddress);
        _ticket.updateWhiteList(to, true);
    }

    function generateRandomSalt(
        uint256 _tokenId
    ) internal view returns (uint256) {
        bytes32 hash = keccak256(
            abi.encodePacked(block.timestamp, msg.sender, _tokenId)
        );
        return uint256(hash);
    }

    function _tokenReward(address to, uint256 amount) internal {
        uint256 balance = _heroToken.balanceOf(address(this));
        if (balance < amount) {
            uint256 shortage = amount - balance;
            _heroToken.mintForPayment(shortage);
        }
        _heroToken.transferFromForPayment(address(this), to, amount);
        emit TokenReward(to, amount);
    }

    function _tokenPaymentForIssueTicket(
        address issuer,
        uint256 amount
    ) internal {
        address issuerAccount = tbaAddress[issuer];

        if (issuerAccount == address(0x00)) revert InvalidAddress();

        _heroToken.transferFromForPayment(issuerAccount, address(this), amount);
        emit TokenPaymentForIssueTicket(issuer, amount);
    }
}
