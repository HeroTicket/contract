// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @dev the ERC-165 identifier for this interface is `0x74420f4c`
interface IERC6551Executable {
    function execute(
        address to,
        uint256 value,
        bytes calldata data,
        uint256 operation
    ) external payable returns (bytes memory);
}
