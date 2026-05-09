// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Guestbook {
    string public errorMessageEmpty = "Message cannot be empty";

    uint256 id = 0;

    event MessagePosted(uint256 id, address indexed author);

    struct GuestMessage {
        uint256 id;
        address author;
        uint256 timestamp;
        string content;
    }

    GuestMessage[] messages;

    function writeToBook(string calldata content) public {
        require(bytes(content).length > 0, errorMessageEmpty);

        id++;
        GuestMessage memory newMsg =
            GuestMessage({id: id, author: msg.sender, content: content, timestamp: block.timestamp});

        messages.push(newMsg);

        emit MessagePosted({id: id, author: msg.sender});
    }

    function getMessageCount() public view returns (uint256) {
        return id;
    }

    function getMessageById(uint256 msgId) public view returns (GuestMessage memory) {
        GuestMessage storage message = messages[msgId - 1];
        return message;
    }
}
