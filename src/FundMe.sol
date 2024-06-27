// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

// Error
error NotOwner();
error TargetAchieved(uint256 ContractBalance,uint256 SenderAmount);
// Address will map to the struct

contract FundMe {
    // Extending UINT256 functionalities
    using PriceConverter for uint256;

    
    uint256 public constant MINIMUM_USD = 5;
    address private immutable i_owner;
    address[] private s_funders;
    
    struct FundersDetails {
        uint256 FundId;
        string Name;
        uint256 Amount;
    }

    FundersDetails private funders;
    
    mapping(address => FundersDetails) private s_addressFunders;
    AggregatorV3Interface private s_pricefeed;
    uint256 private counter = 0;
    uint256 private Target = 50e18;
    

    // Modifiers For verifying the owner
    modifier onlyOwner(){
        // require(msg.sender == i_owner);
        if (msg.sender != i_owner){ 
            revert NotOwner();
            }
        _;
    }


// Limitation :- Contract may receive funds more than 50 ETH
    modifier target(){
        if(address(this).balance>=Target){
            revert TargetAchieved({
                ContractBalance : address(this).balance,
                SenderAmount : msg.value
            });
        }
        _;
    }


    constructor(address chainAddress) {
        i_owner = msg.sender;
        s_pricefeed = AggregatorV3Interface(chainAddress);
    }

// Gets the name as argument
// Modifier checks whether or not the targer is achieved or not.
// convert the received amount and consant amount into their respective USD amount, then proceed with converstion.
// Will create a stuct with data stored in it
// will then them the address to struct

    function fund(string memory name) public payable target  {
        require(msg.value.getConversionRate(s_pricefeed) >= MINIMUM_USD.getConversionRate(s_pricefeed), "You need to spend more ETH!");
        
        FundersDetails memory funder =  FundersDetails({
            FundId : counter,
            Name : name,
            Amount : msg.value
         });
        
        s_addressFunders[msg.sender] = funder;
        s_funders.push(msg.sender);
        counter++;
    }



    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressFunders[funder] = FundersDetails({
            FundId : 0,
            Name : "",
            Amount :0
            });
        }

        s_funders = new address[](0);
        // payable(i_owner).transfer(address(this).balance);
        // payable(msg.sender).transfer(address(this).balance);
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success);
        counter= 0;
    }


    function cheaperWithdraw() public onlyOwner {
        address[] memory funders = s_funders;
        // mappings can't be in memory, sorry!
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            s_addressFunders[funder] = FundersDetails({
            FundId : 0,
            Name : "",
            Amount :0          
            });
        }


        s_funders = new address[](0);
        // payable(msg.sender).transfer(address(this).balance);
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success);
        counter = 0;
        }



// Finding the person with highest amount of funding

        function HighestContribution () public view returns(string memory,uint256) {
            address[] memory funders = s_funders;
            uint256 L_amount = 0;
            string memory FunderWithMostContribution = "";

            for(uint256 counter; counter< funders.length;counter++){
               address user =  funders[counter];
               FundersDetails memory temp_Struct = s_addressFunders[user];  
               if(L_amount <= temp_Struct.Amount){
                FunderWithMostContribution = temp_Struct.Name; 
                L_amount = temp_Struct.Amount;
               }
            }
           return (FunderWithMostContribution,L_amount);
        }



        function getRandomNumber() public view returns (uint256) {
            return uint256(keccak256(abi.encodePacked(blockhash(block.number - 1), msg.sender, block.timestamp)));
        }


    function getVersion() public view returns (uint256) {
        return s_pricefeed.version();
    }

    function getFunder(uint256 index) private view returns (address) {
        return s_funders[index];
    }

    function getFunderDetail(uint256 index) public view returns (string memory,uint256) {
        address user = getFunder(index);
        FundersDetails memory temp = s_addressFunders[user]; 
        string memory name = temp.Name;
        uint256 amount = temp.Amount;
        return (name,amount);
    }


    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getOwnerBalance() public view returns (uint256) {
        uint256 OB = msg.sender.balance;
        return OB;
    }

    

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_pricefeed;
    }

    function returnBalance() public view returns(uint256){
        return address(this).balance;
    }
}