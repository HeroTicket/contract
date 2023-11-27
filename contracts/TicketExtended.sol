// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC6551Account.sol";
import "./ERC6551Registry.sol";
import "./NFTFactory.sol";
import "./interfaces/ITicket.sol";
import "./interfaces/ITicketExtended.sol";
import "./Ticket.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// error 정의

contract TicketExtended is Ownable(msg.sender), ITicketExtended {
    uint256 private _tokenIds;

    ERC6551Registry private _registry;
    ERC6551Account private _account;
    NFTFactory private _nftFactory;

    // tbaAddress mapping 추가
    mapping(address => address) public _tbaAddress;
    // 티켓 주소 배열(소유자 주소 => 보유중인 티켓 컨트랙트 주소 배열)
    mapping(address => address[]) public _ticketAddresses;

    address[] public _tickets;

    constructor() {
        _nftFactory = new NFTFactory();
        _account = new ERC6551Account();
        _registry = new ERC6551Registry();
    }

    // NFT Factory로 부터 Hero Ticket NFT 생성 및 TBA 생성
    function mint(
        address to,
        string memory tokenURI
    ) external payable returns (uint256, address) {
        if (_tbaAddress[to] != address(0x00)) {
            revert("TBA is already exist");
        }
        uint256 tokenId = _tokenIds;
        _tokenIds++;

        uint256 salt = generateRandomSalt();

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

        uint256 newNFTId = _nftFactory.mintNFT(to, tokenURI);
        _tbaAddress[to] = accountAddress;

        emit minted(tokenId);
        return (newNFTId, accountAddress);
    }

    function updateTicketAddresses(
        address buyer,
        address newTicketAddress
    ) external {
        _ticketAddresses[buyer].push(newTicketAddress);
    }

    // emit event
    function issueTicket(
        address _tokenAddress,
        string memory ticketName,
        string memory ticketSymbol,
        string memory ticketUri,
        address initialOwner, // 관리자
        uint256 ticketAmount,
        uint256 ticketPrice
    ) external returns (address) {
        Ticket _ticket = new Ticket(
            address(this),
            _tokenAddress,
            ticketName,
            ticketSymbol,
            ticketUri,
            initialOwner, // 관리자
            ticketAmount,
            ticketPrice
        );

        _tickets.push(address(_ticket));
        address ticketAddress = address(_ticket);
        return ticketAddress;
    }

    // ether로 티켓 구매
    function buyTicketByEther(
        address _ticketAddress,
        address adminAddress
    ) external payable returns (uint256) {
        Ticket _ticket = Ticket(_ticketAddress);
        require(
            _ticket._whiteList(msg.sender),
            "recipient is not in white list"
        );

        uint256 ticketPrice = _ticket._ticketPrice();

        bool success = sendEther(payable(adminAddress), ticketPrice);

        require(success, "Ether transfer failed.");

        uint256 newTicketId = _ticket.buyTicket(msg.sender);

        return newTicketId;
    }

    // emit event
    function buyTicket(
        address _ticketAddress
    ) external payable returns (uint256) {
        Ticket _ticket = Ticket(_ticketAddress);
        require(
            _ticket._whiteList(msg.sender),
            "recipient is not in white list"
        );
        uint256 newTicketId = _ticket.buyTicket(msg.sender);
        return newTicketId;
    }

    function updateWhiteList(
        address _ticketAddress,
        address to
    ) external onlyOwner {
        Ticket _ticket = Ticket(_ticketAddress);
        _ticket.updateWhiteList(to);
    }

    // ownTicket
    function ownedTicket() external view returns (address[] memory) {
        return _ticketAddresses[msg.sender];
    }

    function generateRandomSalt() internal view returns (uint256) {
        bytes32 hash = keccak256(
            abi.encodePacked(block.timestamp, msg.sender, _tokenIds)
        );
        return uint256(hash);
    }

    // 이더 전송을 수행하고 성공 여부를 반환하는 내부 함수
    function sendEther(
        address payable to,
        uint256 amount
    ) internal returns (bool) {
        // 이더 전송
        (bool success, ) = to.call{value: amount}("");

        // 전송 성공 여부 반환
        return success;
    }
}
