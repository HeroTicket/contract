// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ITicketExtended.sol";
import "./ERC6551Account.sol";
import "./ERC6551Registry.sol";
import "./NFTFactory.sol";
import "./HeroToken.sol";
import "./Ticket.sol";

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

    constructor(
        address payable accountImpl,
        address registryImpl,
        address heroToken
    ) {
        _nftFactory = new NFTFactory();
        _account = ERC6551Account(accountImpl);
        _registry = ERC6551Registry(registryImpl);
        _heroToken = HeroToken(heroToken);
    }

    // NFT Factory로 부터 Hero Ticket NFT 생성 및 TBA 생성
    function createTBA(
        address to,
        string memory tokenURI
    ) external payable returns (uint256, address) {
        if (tbaAddress[to] != address(0x00)) {
            revert("TBA already exists");
        }
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

        emit TBACreated(to, accountAddress, tokenId);

        return (tokenId, accountAddress);
    }

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
    ) external returns (address) {
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
            msg.sender,
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
        require(
            issuedTicket[_ticketAddress],
            "ticket is not issued by this contract"
        );

        Ticket _ticket = Ticket(_ticketAddress);

        uint256 ticketPrice = _ticket.ticketEthPrice();
        require(msg.value == ticketPrice, "invalid payment");

        uint256 newTicketId = _ticket.buyTicketByEther{value: ticketPrice}(
            tbaAddress[msg.sender]
        );

        emit TicketSold(_ticketAddress, msg.sender, newTicketId);

        return newTicketId;
    }

    // token으로 티켓 구매
    function buyTicketByToken(
        address _ticketAddress,
        address _buyer
    ) external payable onlyOwner returns (uint256) {
        require(
            issuedTicket[_ticketAddress],
            "ticket is not issued by this contract"
        );
        require(_buyer != address(0x00), "invalid buyer address");

        address buyerAccount = tbaAddress[_buyer];
        require(buyerAccount != address(0x00), "invalid account address");

        Ticket _ticket = Ticket(_ticketAddress);

        uint256 ticketPrice = _ticket.ticketTokenPrice();

        // TODO: approve from buyer or buyerAccount
        uint256 buyerBalance = _heroToken.balanceOf(_buyer);
        uint256 accountBalance = _heroToken.balanceOf(buyerAccount);

        if (buyerBalance + accountBalance < ticketPrice) {
            revert("insufficient balance to buy ticket");
        }

        if (accountBalance < ticketPrice) {
            // transfer from buyer to buyerAccount
            uint256 shortage = ticketPrice - accountBalance;
            _heroToken.transferFromForPayment(_buyer, buyerAccount, shortage);
        }

        // approve from account to ticket contract
        _heroToken.approveForPayment(buyerAccount, _ticketAddress, ticketPrice);

        uint256 newTicketId = _ticket.buyTicketByToken(buyerAccount);

        emit TicketSold(_ticketAddress, _buyer, newTicketId);

        return newTicketId;
    }

    function updateWhiteList(
        address _ticketAddress,
        address to
    ) external onlyOwner {
        require(
            issuedTicket[_ticketAddress],
            "ticket is not issued by this contract"
        );

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
}
