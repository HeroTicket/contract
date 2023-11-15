// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC1271.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "../interfaces/IERC6551Account.sol";
import "../interfaces/IERC6551Executable.sol";
import "./Ticket.sol";

contract ExampleERC6551Account is
    IERC1271,
    IERC6551Account,
    IERC6551Executable
{
    Ticket private _ticket;

    // 외부 계정으로부터 이더를 받을 수 있게하는 fallback 함수
    receive() external payable {}

    // TBA 동작 함수 정의
    // TBA 계정 정보 저장 mapping
    // owner address => nftId => TBA address
    mapping(address => mapping(uint256 => address)) public _ownerTBA;

    // owner address => nft address => TBA address 등록
    function updateTBA(
        string calldata _ownerAddress,
        uint256 calldata _nftId,
        string calldata _tbaAddress
    ) public onlyOwner {
        if (_ownerTBA[_ownerAddress][_nftAddress] != address(0)) {
            revert AlreadyRegistered(_ownerAddress, _nftAddress);
        }
        _ownerTBA[_ownerAddress][_nftAddress] = _tbaAddress;
    }

    // Ticket 확인
    // msg.sender의 TBA안에 들어있는 티켓NFT의 정보를 확인
    function myTicket(_tokenId) public {
        // msg.sender의 _nftId가 존재하는지 확인
        require(
            _ownerTBA[msg.sender][_tokenId] != address(0),
            "NonexistentToken"
        );
        // nft의 TBA 계정 주소를 가져온다
        address ownerTBA = _ownerTBA[msg.sender][_tokenId];
        // TBA안에 들어있는 NFT들을 가져온다
        address[] memory nftList = _ticket.getNFTList(ownerTBA);
    }

    // Ticket 정보 불러오기

    function isValidSigner(
        address signer,
        bytes calldata
    ) external view returns (bytes4) {
        if (_isValidSigner(signer)) {
            return IERC6551Account.isValidSigner.selector;
        }

        return bytes4(0);
    }

    function isValidSignature(
        bytes32 hash,
        bytes memory signature
    ) external view returns (bytes4 magicValue) {
        bool isValid = SignatureChecker.isValidSignatureNow(
            owner(),
            hash,
            signature
        );

        if (isValid) {
            return IERC1271.isValidSignature.selector;
        }

        return "";
    }

    function supportsInterface(
        bytes4 interfaceId
    ) external pure returns (bool) {
        return (interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC6551Account).interfaceId ||
            interfaceId == type(IERC6551Executable).interfaceId);
    }

    function token() public view returns (uint256, address, uint256) {
        bytes memory footer = new bytes(0x60);

        assembly {
            extcodecopy(address(), add(footer, 0x20), 0x4d, 0x60)
        }

        return abi.decode(footer, (uint256, address, uint256));
    }

    function owner() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = token();
        if (chainId != block.chainid) return address(0);

        return IERC721(tokenContract).ownerOf(tokenId);
    }

    function _isValidSigner(address signer) internal view returns (bool) {
        return signer == owner();
    }
}
