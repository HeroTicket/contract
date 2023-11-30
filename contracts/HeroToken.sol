// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HeroToken is ERC20, Ownable(msg.sender) {
    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {
        _mint(msg.sender, 100000000e18);
    }

    // 토큰 결제를 위해 토큰을 전송하는 함수
    function transferFromForPayment(
        address sender,
        address recipient,
        uint256 amount
    ) external onlyOwner returns (bool) {
        _transfer(sender, recipient, amount);
        return true;
    }

    // 토큰 결제를 위해 토큰 인출을 승인하는 함수
    function approveForPayment(
        address owner,
        address spender,
        uint256 value
    ) external onlyOwner returns (bool) {
        _approve(owner, spender, value, false);
        return true;
    }

    // 토큰 결제를 위해 토큰을 생성하는 함수
    function mintForPayment(uint256 amount) external onlyOwner returns (bool) {
        _mint(msg.sender, amount);
        return true;
    }
}
