// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/Blog.sol";
import "forge-std/Script.sol";

contract BlogScript is Script {
    uint256 deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;


    function setUp() public {}

    function run() public {

        vm.startBroadcast(deployerPrivateKey);

        Blog blog = new Blog();

        blog.createPost("The first one", "Not a real address");

        vm.stopBroadcast();
    }
}
