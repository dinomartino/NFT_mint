// Contract elements should be laid out in the following order:
// Pragma statements
// Import statements
// Events
// Errors
// Interfaces
// Libraries
// Contracts

// Inside each contract, library or interface, use the following order:
// Type declarations
// State variables
// Events
// Errors
// Modifiers
// Functions

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Tino_NFT is ERC721URIStorage, Ownable {
    uint256 private immutable i_maxSupply;
    uint256 private s_counter = 0;
    address private s_minter;

    event NFT_minted(address indexed owner);

    constructor(
        uint256 maxSupply,
        address minter
    ) Ownable(msg.sender) ERC721("TinoNFT", "TFT") {
        i_maxSupply = maxSupply;
        s_minter = minter;
    }

    function mint(address to, string memory tokenuri) external payable {
        require(s_counter < i_maxSupply, "All NFT is minted!");
        _safeMint(to, s_counter);
        _setTokenURI(s_counter, tokenuri);
        s_counter++;
        emit NFT_minted(to);
    }

    // Getter functions
    function getMintedAmount() public view returns (uint256) {
        return (s_counter);
    }

    function getMaxSupply() public view returns (uint256) {
        return i_maxSupply;
    }
}
