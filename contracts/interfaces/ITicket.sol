// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// ERC721URIStorage는 이미 ERC721 인터페이스를 상속하므로 별도로 상속할 필요 없음.
// Ownable은 이미 ERC721 상속 중에 상속되었으므로 별도로 상속할 필요 없음.

interface ITicket {
    // 이벤트
    event TicketBuy(
        address indexed to,
        uint256 indexed tokenId,
        string tokenURI
    );
    event TicketTransferred(
        uint256 indexed tokenId,
        address indexed from,
        address indexed to
    );

    event WhiteListUpdated(address indexed to);

    function _whiteList(address) external view returns (bool);

    // 티켓 발행 함수
    function buyTicket(address buyer) external payable returns (uint256);

    // 티켓 전송 함수
    function transferTicket(uint256 _tokenId, address _buyer) external;

    // WhiteList 업데이트 함수
    function updateWhiteList(address to) external returns (bool);

    function isAddressInWhiteList(
        address recipient
    ) external view returns (bool);
}
