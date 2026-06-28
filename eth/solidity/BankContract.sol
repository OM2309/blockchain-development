// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract BankContract {
    mapping(address => uint256) public balance;

    function deposite() public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        balance[msg.sender] = balance[msg.sender] + msg.value;
    }

    function getBalance() public view returns (uint256) {
        return balance[msg.sender];
    }

    function withDraw(uint256 amount) public {
        require(amount >= 0, "Amount must be greater than 0");
        require(balance[msg.sender] >= amount, "Insufficient balance");
        balance[msg.sender] = balance[msg.sender] - amount;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }

        function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
