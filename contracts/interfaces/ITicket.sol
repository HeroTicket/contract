// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ERC721URIStorage는 이미 ERC721 인터페이스를 상속하므로 별도로 상속할 필요 없음.
// Ownable은 이미 ERC721 상속 중에 상속되었으므로 별도로 상속할 필요 없음.

interface ITicket {
    error NonexistentToken(uint256 _tokenId);
    error NotOwner(uint256 _tokenId, address sender);
    error AlreadyRegistered(string _ownerAddress, string _nftAddress);
    error InSufficientBalance(
        address _sender,
        uint256 _senderBalance,
        uint256 _amount
    );
    error PaymentFailed(address _sender, address _recipient, uint256 _amount);

    // 이벤트
    event TicketSold(
        address indexed to,
        uint256 indexed tokenId,
        string tokenURI
    );
    event TicketTransferred(
        uint256 indexed tokenId,
        address indexed from,
        address indexed to
    );

    event PaymentClaimed(
        address indexed claimer,
        uint256 ethAmount,
        uint256 tokenAmount
    );

    event WhiteListUpdated(address indexed to, bool allow);

    function whiteList(address) external view returns (bool);

    // 티켓 발행 함수
    function buyTicketByEther(address buyer) external payable returns (uint256);

    function buyTicketByToken(address buyer) external returns (uint256);

    // 티켓 전송 함수
    function transferTicket(uint256 _tokenId, address _buyer) external;

    // 티켓 발행자에게 결제 대금 정산
    function claimPayment() external;

    // WhiteList 업데이트 함수
    function updateWhiteList(address to, bool allow) external;
}
