// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuthRegistry {
    struct User {
        string username;
        bytes32 passwordHash;
        bool exists;
    }

    mapping(address => User) private users;
    mapping(bytes32 => address) private credentials;

    event UserRegistered(address indexed user, string username);
    event CredentialVerified(address indexed user);

    modifier userExists() {
        require(users[msg.sender].exists, "User does not exist.");
        _;
    }

    function register(string memory username, string memory password) public {
        require(!users[msg.sender].exists, "User already registered.");

        bytes32 passwordHash = keccak256(abi.encodePacked(password));
        users[msg.sender] = User(username, passwordHash, true);
        credentials[passwordHash] = msg.sender;

        emit UserRegistered(msg.sender, username);
    }

    function verifyCredential(string memory password) public userExists {
        bytes32 passwordHash = keccak256(abi.encodePacked(password));
        require(credentials[passwordHash] == msg.sender, "Invalid credentials.");

        emit CredentialVerified(msg.sender);
    }

    function getUserInfo() public view userExists returns (string memory, address) {
        User memory user = users[msg.sender];
        return (user.username, msg.sender);
    }
}