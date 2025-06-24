//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Script} from "forge-std/Script.sol";
import {Tino_NFT} from "../src/TinoNFT.sol";

contract Deploy is Script {
    Tino_NFT public tinoNFT;

    function run() external {
        vm.startBroadcast();
        tinoNFT = new Tino_NFT(20, msg.sender);
        vm.stopBroadcast();
    }
}
