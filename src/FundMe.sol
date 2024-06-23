// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

// Error
error FundMe__NotOwner();
error TargetAchieved();
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
    
    mapping(address => FundersDetails) private s_addressToAmountFunded;
    AggregatorV3Interface private s_pricefeed;
    int256 private counter = 1;
    uint256 private Target = 50e18;
    

    // Modifiers For verifying the owner
    modifier onlyOwner() {
        // require(msg.sender == i_owner);
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    modifier target(){
        if(address(this).balance>=Target){
            revert TargetAchieved();
        }
        _;
    }


    constructor(address chainAddress) {
        i_owner = msg.sender;
        s_pricefeed = AggregatorV3Interface(chainAddress);
    }

    function fund(string memory name) public payable TargetAchieved  {
        require(msg.value.getConversionRate(s_pricefeed) >= MINIMUM_USD, "You need to spend more ETH!");
        
        FundersDetails memory funder =  FundersDetails({
            FundId : counter,
            Name : name,
            Amount : msg.value
         });
        
        s_addressToAmountFunded[msg.sender] = funder;
        s_funders.push(msg.sender);
        counter++;
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // Transfer vs call vs Send
        // payable(msg.sender).transfer(address(this).balance);
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success);
        
    }


    function cheaperWithdraw() public onlyOwner {
        address[] memory funders = s_funders;
        // mappings can't be in memory, sorry!
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // payable(msg.sender).transfer(address(this).balance);
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    function getAddressToAmountFunded(address fundingAddress) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getVersion() public view returns (uint256) {
        return s_pricefeed.version();
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_pricefeed;
    }

    function returnBalance() public view returns(uint256){
        return address(this).balance;
    }
}