// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Wallet is Ownable {
    receive() external payable {
    }

    fallback() external payable {
    }

    function withdraw(address payable _to, uint _amount) onlyOwner external {
        require(address(this).balance >= _amount, "wallet: not enough funds to withdraw");
        _to.transfer(_amount);
    }
}
