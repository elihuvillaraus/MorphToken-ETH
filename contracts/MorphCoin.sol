// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract MorphCoin is
    ERC20,
    ERC20Burnable,
    Pausable,
    Ownable,
    ERC20Permit,
    ERC20Votes
{
    // Events to log on blockchain - Each need an "emmiter" wich triggers the log to be saved.
    event tokensMinted(address indexed owner, uint256 amount, string message);
    event tokensBurned(address indexed owner, uint256 amount, string message);
    event tokensPaused(address indexed owner, string message);
    event tokensUnPaused(address indexed owner, string message);
    event additionalTokensMinted(
        address indexed owner,
        uint256 amount,
        string message
    );

    // Inicia el constructor
    constructor() ERC20("MorphCoin", "MRC") ERC20Permit("MorphCoin") {
        _mint(msg.sender, 1000 * 10**decimals());
        emit tokensMinted(
            msg.sender,
            1000 * 10**decimals(),
            "Initial supply of tokens minted."
        );
    }

    function pause() public onlyOwner {
        _pause();
        emit tokensPaused(msg.sender, "Tokens paused.");
    }

    function unpause() public onlyOwner {
        _unpause();
        emit tokensUnPaused(msg.sender, "Tokens unpaused.");
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
        emit additionalTokensMinted(
            msg.sender,
            amount,
            "Additional tokens minted."
        );
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Votes) {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
        emit additionalTokensMinted(
            msg.sender,
            amount,
            "Additional tokens minted."
        );
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
        emit tokensBurned(msg.sender, amount, "Tokens burned.");
    }
}
