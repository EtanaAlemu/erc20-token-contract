// contracts/MTToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract MTToken is ERC20, Ownable, Pausable, ERC20Capped {
    uint256 public rewardPerBlock;

    constructor(
        uint256 _cap,
        uint256 initialSupply,
        uint256 _rewardPerBlock
    ) ERC20("MartrezaToken", "MTT") ERC20Capped(_cap) {
        // Mint an initial supply, but ensure it doesn't exceed the cap
        initialSupply = initialSupply * 10 ** uint256(decimals());
        require(
            initialSupply <= _cap * 10 ** uint256(decimals()),
            "Initial supply exceeds the cap"
        );
        _mint(msg.sender, initialSupply);
        rewardPerBlock = _rewardPerBlock * 10 ** uint256(decimals());
    }

    function pauseToken() public onlyOwner {
        _pause();
    }

    function unpauseToken() public onlyOwner {
        _unpause();
    }

    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
        require(account != address(0), "ERC20: mint to the zero address");
        super._mint(account, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal whenNotPaused override {
        require(
            to != address(0),
            "ERC20: transfer to the zero address is not allowed"
        );

        require(
            from != address(0),
            "ERC20: transfer from the zero address is not allowed"
        );
        super._beforeTokenTransfer(from, to, amount);
    }

    function updateRewardPerBlock(uint256 _newReward) public onlyOwner {
        rewardPerBlock = _newReward * 10 ** uint256(decimals());
    }
}
