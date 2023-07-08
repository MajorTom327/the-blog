// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Blog.sol";

contract BlogTest is Test {
    event PostCreated(uint256 id, string ipfsUrl, uint256 timestamp);

    function setUp() public {
    }


    function testAddBlogPost(string memory title, string memory url) public {
        Blog blog = new Blog();
        assertEq(blog.getPostsCount(), 0);
        blog.createPost(title, url);
        assertEq(blog.getPostsCount(), 1);
        (string memory _title, string memory _url,) = blog.getPost(0);
        assertEq(_url, url);
        assertEq(_title, title);
    }

    function testShouldEmitEvent() public {
        Blog blog = new Blog();

        vm.expectEmit(true, true, false, true);
        emit PostCreated(0, "url", block.timestamp);
        blog.createPost("title", "url");
    }

    function testFailToCreateIfNotOwner() public {
        Blog blog = new Blog();

        vm.prank(address(0xdeadbeef));
        blog.createPost("title", "url");
    }

    function testBlogCount() public {
      Blog blog = new Blog();

      assertEq(blog.getPostsCount(), 0);
      blog.createPost("title", "url");
      assertEq(blog.getPostsCount(), 1);
      blog.createPost("title", "url");
      assertEq(blog.getPostsCount(), 2);
    }

    function testGetBlogPost() public {
      Blog blog = new Blog();

      blog.createPost("title", "url");
      vm.warp(2);
      blog.createPost("title 2", "the other url");

      (string memory title, string memory url, uint256 timestamp) = blog.getPost(0);

      assertEq(title, "title");
      assertEq(url, "url");
      assertEq(timestamp, 1);

      (title, url, timestamp) = blog.getPost(1);
      assertEq(title, "title 2");
      assertEq(url, "the other url");
      assertEq(timestamp, 2);
    }

    function testGetInexistantBlogPost() public {
      Blog blog = new Blog();

      vm.expectRevert(bytes("Index out of bounds"));
      (bool revertsAsExpected, ) = address(blog).call(abi.encodeWithSignature("getPost(uint256)", 0));
      assertTrue(revertsAsExpected, "expectRevert: call did not revert");
    }

    function testGetAllPosts() public {
      Blog blog = new Blog();

      blog.createPost("title", "url");
      vm.warp(2);
      blog.createPost("title 2", "the other url");

      Blog.Post[] memory posts = blog.getAllPosts();

      assertEq(posts.length, 2);

      assertEq(posts[0].title, "title");
      assertEq(posts[0].ipfsUrl, "url");
      assertEq(posts[0].timestamp, 1);

      assertEq(posts[1].title, "title 2");
      assertEq(posts[1].ipfsUrl, "the other url");
      assertEq(posts[1].timestamp, 2);
    }

    function testUpdateTitle(string memory previousTitle, string memory newTitle) public {
      vm.assume( keccak256(abi.encodePacked(previousTitle)) != keccak256(abi.encodePacked(newTitle)));

      Blog blog = new Blog();

      blog.createPost(previousTitle, "url");
      (string memory title,,) = blog.getPost(0);

      assertEq(title, previousTitle);

      blog.updateTitle(0, newTitle);
      (title,,) = blog.getPost(0);

      assertEq(title, newTitle);
    }

    function testDonation() public {
      Blog blog = new Blog();
      address blogOwner = blog.owner();

      address user = address(0xdeadbeef);

      vm.startPrank(user);
      vm.deal(blogOwner, 1 ether);
      vm.deal(user, 1 ether);

      address(blog).call{value: 1 ether}("");

      vm.stopPrank();

      assertEq(blogOwner.balance, 2 ether);






    }

    function testWithdraw() public {
      Blog blog = new Blog();

      uint256 initialBalance = address(this).balance;
      assertEq(address(blog).balance, 0);

      vm.deal(address(blog), 1 ether);
      assertEq(address(blog).balance, 1 ether);

      blog.withdraw();

      assertEq(address(blog).balance, 0);
      assertEq(address(this).balance, initialBalance + 1 ether);
    }

    fallback() external payable {}
    receive() external payable {}
}
