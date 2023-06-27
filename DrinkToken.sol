// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title Contract for Beer NFT Creation
///@author Stanislav Bozhimirov
///@notice This is a basic contract for token creation with predefined data

contract DrinkToken is ERC721, ERC721URIStorage, Ownable {
    uint256 balance;
    address creator;
    uint256 id;
    string uri;
    uint256 price;
    uint256 tokenId;
    string nameToken;
    string symbolToken;
    mapping(address => uint256) buyers;
    mapping (uint256 => address) minted;

    uint256 _tokenIdCounter;

    event Track(
        string indexed _function,
        address sender,
        uint256 value,
        bytes data
    );

    ///@dev for the ERC721 token is used predefined info, can be changed before deploying
    constructor(uint256 _id, string memory _nameToken, string memory _symbol, 
        address _creator, string memory _uri, uint256 _price) ERC721("_nameToken", "_abbreviation") {
        require(bytes(_nameToken).length > 0, "Name required");
        require(bytes(_symbol).length > 0, "Abbreviation required");
        require(bytes(_uri).length > 0, "URI required");
        require(_price > 0, "Price required");
        nameToken = _nameToken;
        symbolToken = _symbol;
        uri = _uri;
        id = _id;
        transferOwnership(_creator);
        creator = _creator;
        price = _price;
    }
    
    // Modifier to check if the function caller has been contributor
    modifier notBuyer() {
        require(buyers[msg.sender] == 0, "already have the item");
        _;
    }


    ///@notice mint Token to specified address
    ///@dev automatic increment of token id, adding token URI upon minting
    ///@param to address to receiver of the token
    function safeMint(address to) external payable notBuyer(){
        require(msg.value > price - 1);
        balance += msg.value;
        buyers[msg.sender] = msg.value;
        tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        _tokenIdCounter++;
    }

    function priceModifier(uint256 newPrice) external onlyOwner {
        price = newPrice;
    }


     /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOfNFT(uint256 Id) public view returns (address) {
        address owner = _ownerOf(Id);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    // The following functions are overrides required by Solidity.

    function _burn(
        uint256 Id
    ) internal  override(ERC721, ERC721URIStorage) {
        super._burn(Id);
    }

    function tokenURI(
        uint256 Id
    ) public  view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(Id);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public  view override(ERC721, ERC721URIStorage) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function getId() public view returns(uint256) {
        uint256 Id = tokenId;
        return Id;
    }

    function getNameToken() public view returns(string memory){
        string memory nameT = nameToken;
        return nameT;
    }

    
    /** @dev Function to give the received funds to project starter.
     */
    function payOut() external onlyOwner {
        require(msg.sender == creator);
        require(
            address(this).balance > 0,
            "no funds"
        );
        uint256 totalRaised = address(this).balance;
        balance = 0;

        (bool success, ) = payable(owner()).call{value: totalRaised}("");
        require(
            success,
            "Address: unable to send value, recepient may have reverted"
        );
    }

    receive() external payable {}


}
