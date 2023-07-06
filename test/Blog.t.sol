// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Blog.sol";

contract BlogTest is Test {

    event PostCreated(string ipfsUrl, uint256 timestamp);

    function setUp() public {
    }

    function testAddBlogPost() public {
        Blog blog = new Blog();
        assertEq(blog.getPostsCount(), 0);
        blog.createPost("url");
        assertEq(blog.getPostsCount(), 1);
    }

    function testShouldEmitEvent() public {
        Blog blog = new Blog();

        vm.expectEmit(true, true, false, true);
        emit PostCreated("url", block.timestamp);
        blog.createPost("url");
    }

    function testFailToCreateIfNotOwner() public {
        Blog blog = new Blog();

        vm.prank(address(0xdeadbeef));
        blog.createPost("url");
    }

    function testBlogCount() public {
      Blog blog = new Blog();

      assertEq(blog.getPostsCount(), 0);
      blog.createPost("url");
      assertEq(blog.getPostsCount(), 1);
      blog.createPost("url");
      assertEq(blog.getPostsCount(), 2);
    }

    function testGetBlogPost() public {
      Blog blog = new Blog();

      blog.createPost("url");
      vm.warp(2);
      blog.createPost("the other url");

      (string memory url, uint256 timestamp) = blog.getPost(0);


      assertEq(url, "url");
      assertEq(timestamp, 1);

      (url, timestamp) = blog.getPost(1);
      assertEq(url, "the other url");
      assertEq(timestamp, 2);
    }
}
