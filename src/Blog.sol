// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/access/Ownable.sol";

contract Blog is Ownable {
    struct Post {
        string title;
        string ipfsUrl;
        uint256 timestamp;
    }

    mapping(uint256 => Post) public posts;
    uint256 lastPostIndex;

    event PostCreated(uint256 id, string ipfsUrl, uint256 timestamp);

    function createPost(string memory _title, string memory _ipfsUrl) public onlyOwner {
      posts[lastPostIndex] = Post(_title, _ipfsUrl, block.timestamp);
      lastPostIndex++;
      emit PostCreated(lastPostIndex - 1, _ipfsUrl, block.timestamp);
    }

    function updateTitle(uint256 _index, string memory _title) public onlyOwner {
      require(_index < lastPostIndex, "Index out of bounds");
      Post storage post = posts[_index];
      post.title = _title;
    }

    function getAllPosts() public view returns (Post[] memory) {
      Post[] memory _posts = new Post[](lastPostIndex);
      for (uint256 i = 0; i < lastPostIndex; i++) {
        Post storage post = posts[i];
        _posts[i] = Post(post.title, post.ipfsUrl, post.timestamp);
      }
      return _posts;
    }

    function getPost(uint256 _index) public view returns (string memory title, string memory ipfsUrl, uint256 timestamp) {
      require(_index < lastPostIndex, "Index out of bounds");
      Post memory post = posts[_index];
      return (post.title, post.ipfsUrl, post.timestamp);
    }

    function getPostsCount() public view returns (uint256) {
      return lastPostIndex;
    }

}
