// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/interfaces/IERC1271.sol";
import "@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol";
import "./interfaces/IERC6551Account.sol";
import "./interfaces/IERC6551Executable.sol";
import "./interfaces/ITicket.sol";

contract ERC6551Account is IERC1271, IERC6551Account, ITicket {
    uint256 public nonce;

    // excutecall(transfer)
    function execute(
        address ticketContractAddress,
        uint256 tokenId,
        address to
    ) external payable returns (uint256 result) {
        require(msg.sender == owner(), "Not token owner");

        ++nonce;

        emit TransferExecuted(to, value, data);

        bool success;
        // parameter로 받은 ticketContractAddress를 가지고 ticketContract 생성
        ITicket ticketContract = ITicket(ticketContractAddress);

        // TicketContract안에 있는 transfer 함수 실행
        (success, result) = ticketContract.transfer{value: msg.value}(
            tokenId,
            to
        );

        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        } else {
            return result;
        }
    }

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

    function token() public view virtual returns (uint256, address, uint256) {
        bytes memory footer = new bytes(0x60);

        assembly {
            extcodecopy(address(), add(footer, 0x20), 0x4d, 0x60)
        }

        return abi.decode(footer, (uint256, address, uint256));
    }

    function owner() public view returns (address) {
        (uint256 chainId, address tokenContract, uint256 tokenId) = this
            .token();
        if (chainId != block.chainid) return address(0);

        return IERC721(tokenContract).ownerOf(tokenId);
    }

    function _isValidSigner(address signer) internal view returns (bool) {
        return signer == owner();
    }
}
