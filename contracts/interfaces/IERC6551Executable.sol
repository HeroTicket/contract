// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @dev the ERC-165 identifier for this interface is `0x74420f4c`
interface IERC6551Executable {
    function execute(
        address ticketContractAddress,
        uint256 tokenId,
        address to
    ) external payable returns (uint256 result);
}
