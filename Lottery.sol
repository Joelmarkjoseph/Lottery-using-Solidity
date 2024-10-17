// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract Lottery {
    // Entities - manager, players, and winner
    address public manager;
    address payable[] public players;
    address payable public winner;

    // Constructor to initialize manager
    constructor() {
        manager = msg.sender;
    }

    // Function to participate in the lottery by paying 1 ether
    function participate() public payable {
        require(msg.value == 1 ether, "Please pay 1 ether only");
        players.push(payable(msg.sender));
    }

    // Function to view contract's balance, restricted to manager
    function getBalance() public view returns (uint) {
        require(manager == msg.sender, "You are not the manager");
        return address(this).balance;
    }

    // Function to generate a pseudo-random number
    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    // Function for the manager to pick a winner, requiring at least 3 players
    function pickWinner() public {
        require(manager == msg.sender, "You are not the manager");
        require(players.length >= 3, "Players are less than 3");

        uint r = random();
        uint index = r % players.length;
        winner = players[index];

        // Transfer the contract balance to the winner and reset the players array
        winner.transfer(getBalance());
        players = new address payable [](0);
    }
}
