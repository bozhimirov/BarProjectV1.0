// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "hardhat/console.sol";
import "./DrinkToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";




contract BarPlatform {

    uint256 drinkId;
    
    string private BeerUri =
        "ipfs://QmUyPtLpEv1ci4nHsxcGKNCz6K2t8VxRL7L5zCZMovp9E1";
        
    string private CoffeeUri =
        "ipfs://QmUNo3djMSTeuJP5SK1uyMJMQbdgP4C1tNXqv49QJc1psj";


    struct DrinkTokens {
        uint256 newDrinkId;
        string _name;
        string _abbreviation;
        string _uri;
        uint256 _price;
        address _address;
    }
    DrinkTokens[] public drinkTokensList; // An array of 'drinkTokens' structs

    // address newDrinkTokenAddress;


    event newTokenevent(DrinkTokens);

    function createToken(
        string memory _name,
        string memory _abbreviation,
        string memory _uri,
        uint256 _price
    ) external payable {

        uint256 newDrinkId = drinkId;
        DrinkToken newDrinkToken = new DrinkToken(
            newDrinkId,
            _name,
            _abbreviation,
            msg.sender,
            _uri,
            _price
        );

        drinkTokensList.push(DrinkTokens({
                newDrinkId: newDrinkId,
                _name: _name,
                _abbreviation: _abbreviation,
                _uri: _uri,
                _price: _price,
                _address: address(newDrinkToken)
                
            })
            );
        emit newTokenevent(DrinkTokens({
                newDrinkId: newDrinkId,
                _name: _name,
                _abbreviation: _abbreviation,
                _uri: _uri,
                _price: _price,
                _address: address(newDrinkToken)
                
            }));
        drinkId++;
    }

    /** @dev Function to get all projects' contract addresses.
     * @return A list of all projects' contract addreses
     */
    function returnAllTokens() external view returns (DrinkTokens[] memory) {
        return drinkTokensList;
    }


        

    function buyDrink(uint256 id) external payable {
        
        address  addressToken = drinkTokensList[id]._address;
        DrinkToken(payable( addressToken)).safeMint(msg.sender);
        uint256 tokenId =  DrinkToken(payable( addressToken)).getId();
        // console.log(connectToDrink.getNameToken());
        // connectToDrink.safeMint(msg.sender);
        console.log(tokenId);



        // DrinkToken myInteractionToken = new DrinkToken(payable(addressToken));
        // console.log(myInteractionToken.name());
    }
}