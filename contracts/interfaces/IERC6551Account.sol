// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @dev the ERC-165 identifier for this interface is `0x6faff5f1`
interface IERC6551Account {
    receive() external payable;

    function token()
        external
        view
        returns (uint256 chainId, address tokenContract, uint256 tokenId);

    function state() external view returns (uint256);

    function isValidSigner(
        address signer,
        bytes calldata context
    ) external view returns (bytes4 magicValue);
}
