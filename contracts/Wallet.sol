// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Wallet is Ownable {
    struct Transaction {
        uint id;
        address from;
        address to;
        uint amount;
        uint date;
    }

    uint256 internal TransactionNumber;
    mapping(uint => Transaction) internal Transactions;

    function addTransaction(address _from, address _to, uint _amount, uint _date) private {
        Transactions[TransactionNumber] = Transaction(TransactionNumber, _from, _to, _amount, _date);
        TransactionNumber++;
    }

    receive() external payable {
        addTransaction(msg.sender, address(this), msg.value, block.timestamp);
    }

    fallback() external payable {
    }

    function withdraw(address payable _to, uint _amount) onlyOwner external {
        require(address(this).balance >= _amount, "wallet: not enough funds to withdraw");
        _to.transfer(_amount);
        addTransaction(address(this), _to, _amount, block.timestamp);
    }

    function getTransactions() public view returns (Transaction[] memory) {
        Transaction[] memory txs = new Transaction[](TransactionNumber);
        for (uint256 i=0; i < TransactionNumber; i++) {
            txs[i] = Transactions[i];
        }
        return txs;
    }
}
