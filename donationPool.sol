// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonationPool {
    address payable public owner;
    address payable public charity;
    
    mapping(address => uint256) public donations;
    uint256 public totalDonations;

    // The deployer is set as the owner
    function setOwner() public {
        if (owner == address(0)) {
            owner = payable(msg.sender);
        }
    }

    // Set the charity address
    function setCharity(address payable _charity) public {
        require(msg.sender == owner, "Only owner can set charity");
        charity = _charity;
    }

    // Function to receive donations
    receive() external payable {
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
    }

    // Withdraw funds to charity
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        require(charity != address(0), "Charity not set");
        require(address(this).balance > 0, "No funds available");

        uint256 amount = address(this).balance;
        charity.transfer(amount);
    }

    // Check contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
