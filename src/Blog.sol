// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/access/Ownable.sol";

contract Blog is Ownable {
    struct Post {
        string ipfsUrl;
        uint256 timestamp;
    }

    Post[] public posts;

    event PostCreated(string ipfsUrl, uint256 timestamp);

    function createPost(string memory _ipfsUrl) public onlyOwner {
        posts.push(Post(_ipfsUrl, block.timestamp));
        emit PostCreated(_ipfsUrl, block.timestamp);
    }

    function getPost(uint256 _index) public view returns ( string memory ipfsUrl, uint256 timestamp) {
        Post memory post = posts[_index];
        return (post.ipfsUrl, post.timestamp);
    }

    function getPostsCount() public view returns (uint256) {
        return posts.length;
    }

}
