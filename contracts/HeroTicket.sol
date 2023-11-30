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
import "./TicketImageConsumer.sol";

error TBAAlreadyExists();
error TicketNotIssuedByHeroTicket();
error InvalidPaymentAmount();

contract HeroTicket is Ownable(msg.sender), ITicketExtended {
    ERC6551Registry private _registry;
    ERC6551Account private _account;
    NFTFactory private _nftFactory;
    HeroToken private _heroToken;
    TicketImageConsumer private _ticketImageConsumer;

    // TBA 주소 매핑(소유자 주소 => TBA 컨트랙트 주소)
    mapping(address => address) public tbaAddress;
    // 티켓 주소 매핑(소유자 주소 => 보유중인 티켓 컨트랙트 주소 배열)
    mapping(address => address[]) public ownedTickets;
    // 티켓 컨트랙트 주소 매핑(티켓 컨트랙트 주소 => 불리언)
    mapping(address => bool) public issuedTicket;
    // 티켓 컨트랙트 주소 배열
    address[] public _tickets;

    constructor(
        address payable accountImpl,
        address registryImpl,
        address ticketImageConsumerImpl
    ) {
        // nftFactory와 heroToken은 컨트랙트 생성시에 함께 생성
        _nftFactory = new NFTFactory();
        _heroToken = new HeroToken("HeroToken", "HT");

        // account, registry, ticketImageConsumer는 생성자에서 주입
        _account = ERC6551Account(accountImpl);
        _registry = ERC6551Registry(registryImpl);
        _ticketImageConsumer = TicketImageConsumer(ticketImageConsumerImpl);
    }

    function ticketsByOwner(
        address owner
    ) external view returns (address[] memory) {
        return ownedTickets[owner]; // 티켓 컨트랙트 주소 배열 반환
    }

    function tokenBalanceOf(address owner) external view returns (uint256) {
        return _heroToken.balanceOf(owner); // TBA 주소의 토큰 잔액 반환
    }

    function hasTicket(
        address owner,
        address ticketAddress
    ) external view returns (bool) {
        Ticket _ticket = Ticket(ticketAddress); // 티켓 컨트랙트 인스턴스 생성
        return _ticket.hasTicket(owner); // 티켓 컨트랙트의 hasTicket 함수 호출
    }

    function isWhiteListed(
        address ticketAddress,
        address to
    ) external view returns (bool) {
        Ticket _ticket = Ticket(ticketAddress); // 티켓 컨트랙트 인스턴스 생성
        return _ticket.whiteList(to); // 티켓 컨트랙트의 isWhiteListed 함수 호출
    }

    function ticketInfo(
        address ticketAddress
    )
        external
        view
        returns (address, uint256, uint256, uint256, uint256, uint256)
    {
        Ticket _ticket = Ticket(ticketAddress); // 티켓 컨트랙트 인스턴스 생성

        address issuer = _ticket.issuerAddress(); // 티켓 발행자 주소
        uint256 remainTicketAmount = _ticket.remainTicketAmount(); // 남은 티켓 수량
        uint256 ticketEthPrice = _ticket.ticketEthPrice(); // 티켓 결제 금액(ether)
        uint256 ticketTokenPrice = _ticket.ticketTokenPrice(); // 티켓 결제 금액(token)
        uint256 ticketSaleStartAt = _ticket.ticketSaleStartAt(); // 티켓 판매 시작 시점
        uint256 ticketSaleEndAt = _ticket.ticketSaleEndAt(); // 티켓 판매 종료 시점

        return (
            issuer,
            remainTicketAmount,
            ticketEthPrice,
            ticketTokenPrice,
            ticketSaleStartAt,
            ticketSaleEndAt
        ); // 티켓 정보 반환
    }

    // NFT Factory로 부터 Hero Ticket NFT 생성 및 TBA 생성
    function createTBA(
        address to,
        string memory tokenURI
    ) external payable onlyOwner returns (uint256, address) {
        if (tbaAddress[to] != address(0x00)) revert TBAAlreadyExists(); // 이미 TBA가 존재하는 경우

        uint256 tokenId = _nftFactory.mintNFT(to, tokenURI); // NFT 생성

        uint256 salt = generateRandomSalt(tokenId); // salt 생성

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

        require(accountAddress == expectAddress, "Account creation failed"); // TBA account 생성 검증

        tbaAddress[to] = accountAddress; // TBA 주소 매핑 추가

        _tokenReward(accountAddress, 1000); // 토큰 보상 지급

        emit TBACreated(to, accountAddress, tokenId); // 이벤트 발생

        return (tokenId, accountAddress); // tokenId, TBA 주소 반환
    }

    function acceptOwnership() external onlyOwner {
        _ticketImageConsumer.acceptOwnership(); // ticketImageConsumer 컨트랙트의 소유권 이전
    }

    // 티켓 ai 이미지 생성 함수
    // requestId 반환
    function requestTicketImage(
        bytes memory encryptedSecretsUrls,
        string memory location,
        string memory keyword
    ) external onlyOwner returns (bytes32) {
        // ticketImageConsumer 컨트랙트로부터 requestId를 받아옴
        bytes32 requestId = _ticketImageConsumer.requestTicketImage(
            encryptedSecretsUrls,
            location,
            keyword
        );

        emit TicketImageRequestCreated(requestId, location, keyword); // 이벤트 발생

        return requestId; // requestId 반환
    }

    // requests mapping에서 requestId로 이미지 정보를 가져옴
    function requests(
        bytes32 requestId
    )
        external
        view
        returns (uint256, string memory, string memory, string memory, bool)
    {
        return _ticketImageConsumer.requests(requestId); // 이미지 생성 요청 정보 반환
    }

    // 티켓 발행
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
        _tokenPaymentForIssueTicket(issuer, 500); // 토큰 차감

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
        ); // 티켓 컨트랙트 생성

        address ticketAddress = address(_ticket); // 티켓 컨트랙트 주소

        issuedTicket[ticketAddress] = true; // 티켓 컨트랙트 주소 매핑 추가

        _tickets.push(ticketAddress); // 티켓 컨트랙트 주소 배열에 추가

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
        ); // 이벤트 발생

        return ticketAddress; // 티켓 컨트랙트 주소 반환
    }

    // ether로 티켓 구매
    function buyTicketByEther(
        address _ticketAddress
    ) external payable returns (uint256) {
        if (!issuedTicket[_ticketAddress]) revert TicketNotIssuedByHeroTicket(); // 티켓 컨트랙트 주소가 아닌 경우

        address buyer = msg.sender; // 구매자 주소
        if (buyer == address(0x00)) revert InvalidAddress(); // 구매자 주소가 없는 경우

        address payable buyerAccount = payable(tbaAddress[buyer]); // 구매자의 TBA 주소
        if (buyerAccount == address(0x00)) revert InvalidAddress(); // 구매자의 TBA 주소가 없는 경우

        Ticket _ticket = Ticket(_ticketAddress); // 티켓 컨트랙트 인스턴스 생성

        uint256 ticketPrice = _ticket.ticketEthPrice(); // 티켓 가격 조회

        if (msg.value != ticketPrice) revert InvalidPaymentAmount(); // 지불 금액이 티켓 가격과 다른 경우

        uint256 newTicketId = _ticket.buyTicketByEther{value: ticketPrice}(
            buyerAccount
        ); // 티켓 구매

        _tokenReward(buyerAccount, 1000); // 토큰 보상 지급

        emit TicketSold(
            _ticketAddress,
            msg.sender,
            newTicketId,
            TicketSaleType.ETHER
        ); // 이벤트 발생

        return newTicketId; // 티켓 아이디 반환
    }

    // token으로 티켓 구매
    function buyTicketByToken(
        address _ticketAddress,
        address _buyer
    ) external onlyOwner returns (uint256) {
        if (!issuedTicket[_ticketAddress]) revert TicketNotIssuedByHeroTicket(); // 티켓 컨트랙트 주소가 아닌 경우
        if (_buyer == address(0x00)) revert InvalidAddress(); // 구매자 주소가 없는 경우

        address buyerAccount = tbaAddress[_buyer]; // 구매자의 TBA 주소
        if (buyerAccount == address(0x00)) revert InvalidAddress(); // 구매자의 TBA 주소가 없는 경우

        Ticket _ticket = Ticket(_ticketAddress); // 티켓 컨트랙트 인스턴스 생성

        uint256 ticketPrice = _ticket.ticketTokenPrice(); // 티켓 토큰 가격 조회

        uint256 accountBalance = _heroToken.balanceOf(buyerAccount); // 구매자의 토큰 잔액 조회

        if (accountBalance < ticketPrice) revert InvalidPaymentAmount(); // 구매자의 토큰 잔액이 티켓 가격보다 작은 경우

        _heroToken.approveForPayment(buyerAccount, _ticketAddress, ticketPrice); // 티켓 컨트랙트에서 transferFrom을 호출하기 위한 토큰 승인

        uint256 newTicketId = _ticket.buyTicketByToken(buyerAccount); // 티켓 구매

        emit TicketSold(
            _ticketAddress,
            _buyer,
            newTicketId,
            TicketSaleType.TOKEN
        ); // 이벤트 발생

        return newTicketId; // 티켓 아이디 반환
    }

    // 화이트리스트 업데이트
    function updateWhiteList(
        address _ticketAddress,
        address to
    ) external onlyOwner {
        if (!issuedTicket[_ticketAddress]) revert TicketNotIssuedByHeroTicket(); // 티켓 컨트랙트 주소가 아닌 경우
        if (to == address(0x00)) revert InvalidAddress(); // 대상 주소가 없는 경우

        Ticket _ticket = Ticket(_ticketAddress); // 티켓 컨트랙트 인스턴스 생성

        _ticket.updateWhiteList(to, true); // 티켓 컨트랙트의 화이트리스트 업데이트
    }

    // 랜덤 salt 생성
    function generateRandomSalt(
        uint256 _tokenId
    ) internal view returns (uint256) {
        bytes32 hash = keccak256(
            abi.encodePacked(block.timestamp, msg.sender, _tokenId)
        );
        return uint256(hash);
    }

    // 토큰 보상 지급
    function _tokenReward(address to, uint256 amount) internal {
        uint256 balance = _heroToken.balanceOf(address(this)); // 컨트랙트의 토큰 잔액

        // 컨트랙트의 토큰 잔액이 amount보다 작으면 토큰 발행
        if (balance < amount) {
            uint256 shortage = amount - balance;
            _heroToken.mintForPayment(shortage);
        }

        _heroToken.transferFromForPayment(address(this), to, amount); // 토큰 지급

        emit TokenReward(to, amount); // 이벤트 발생
    }

    // 토큰 결제
    function _tokenPaymentForIssueTicket(
        address issuer,
        uint256 amount
    ) internal {
        address issuerAccount = tbaAddress[issuer]; // 발행자의 TBA 주소

        if (issuerAccount == address(0x00)) revert InvalidAddress(); // 발행자의 TBA 주소가 없는 경우

        _heroToken.transferFromForPayment(issuerAccount, address(this), amount); // 발행자의 TBA로부터 토큰 차감

        emit TokenPaymentForIssueTicket(issuer, amount); // 이벤트 발생
    }
}
