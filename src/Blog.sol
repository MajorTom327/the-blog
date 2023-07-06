// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/access/Ownable.sol";

contract Blog is Ownable {
    struct Post {
        string ipfsUrl;
        uint256 timestamp;
    }

    mapping(uint256 => Post) public posts;
    uint256 lastPostIndex;

    event PostCreated(uint256 id, string ipfsUrl, uint256 timestamp);

    function createPost(string memory _ipfsUrl) public onlyOwner {
      posts[lastPostIndex] = Post(_ipfsUrl, block.timestamp);
      lastPostIndex++;
      emit PostCreated(lastPostIndex - 1, _ipfsUrl, block.timestamp);
    }

    function getPost(uint256 _index) public view returns ( string memory ipfsUrl, uint256 timestamp) {
      require(_index < lastPostIndex, "Index out of bounds");
      Post memory post = posts[_index];
      return (post.ipfsUrl, post.timestamp);
    }

    function getPostsCount() public view returns (uint256) {
      return lastPostIndex;
    }

}
