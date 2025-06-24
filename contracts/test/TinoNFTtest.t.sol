// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Tino_NFT} from "../src/TinoNFT.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TinoNFTTest is Test {
    Tino_NFT tinoNFT;
    address owner = address(0x1);

    address user1 = address(0x3);
    address user2 = address(0x4);
    uint256 maxSupply = 100;
    string tokenURI = "ipfs://QmTestURI";

    function setUp() public {
        // Deploy the contract with owner and minter
        vm.prank(owner);
        tinoNFT = new Tino_NFT(maxSupply);
    }

    function test_Deployment() public view {
        // Test owner
        assertEq(tinoNFT.owner(), owner, "Owner should be set correctly");
        // Test max supply
        assertEq(
            tinoNFT.getMaxSupply(),
            maxSupply,
            "Max supply should be set correctly"
        );
        // Test counter
        assertEq(tinoNFT.getMintedAmount(), 0, "Counter should start at 0");
        // Test name and symbol
        assertEq(tinoNFT.name(), "TinoNFT", "Name should be TinoNFT");
        assertEq(tinoNFT.symbol(), "TFT", "Symbol should be TFT");
    }

    function test_Mint_Success() public {
        tinoNFT.mint(user1, tokenURI);

        // Check ownership
        assertEq(tinoNFT.ownerOf(0), user1, "NFT should be owned by user1");
        // Check token URI
        assertEq(
            tinoNFT.tokenURI(0),
            tokenURI,
            "Token URI should be set correctly"
        );
        // Check counter
        assertEq(tinoNFT.getMintedAmount(), 1, "Counter should increment to 1");
        // Check event
        vm.expectEmit(true, false, false, false);
        emit Tino_NFT.NFT_minted(user1);
        tinoNFT.mint(user1, tokenURI);
    }

    function test_Mint_MaxSupply() public {
        // Deploy with maxSupply = 1
        vm.prank(owner);
        Tino_NFT smallSupplyNFT = new Tino_NFT(1);

        // Mint one NFT
        smallSupplyNFT.mint(user1, tokenURI);

        // Try to mint another, should revert
        vm.expectRevert("All NFT is minted!");
        smallSupplyNFT.mint(user1, tokenURI);
    }

    function test_Mint_CounterIncrement() public {
        tinoNFT.mint(user1, tokenURI);
        assertEq(
            tinoNFT.getMintedAmount(),
            1,
            "Counter should be 1 after first mint"
        );

        tinoNFT.mint(user1, tokenURI);
        assertEq(
            tinoNFT.getMintedAmount(),
            2,
            "Counter should be 2 after second mint"
        );
    }

    function test_Getters() public {
        // Test getMintedAmount
        assertEq(
            tinoNFT.getMintedAmount(),
            0,
            "getMintedAmount should return 0 initially"
        );
        tinoNFT.mint(user1, tokenURI);
        assertEq(
            tinoNFT.getMintedAmount(),
            1,
            "getMintedAmount should return 1 after mint"
        );

        // Test getMaxSupply
        assertEq(
            tinoNFT.getMaxSupply(),
            maxSupply,
            "getMaxSupply should return maxSupply"
        );
    }
}
