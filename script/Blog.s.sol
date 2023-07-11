// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "../src/Blog.sol";
import "forge-std/Script.sol";

contract BlogScript is Script {
    address deployer = vm.envAddress("DEPLOYER_ADDRESS");

    function setUp() public {}

    function run() public {

        vm.startBroadcast(deployer);

        new Blog();

        vm.stopBroadcast();
    }
}
