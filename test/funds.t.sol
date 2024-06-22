// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

//Checking the owner of the contract
//Checking if the funds are being transferred into the contract.
//Checking successfull submission of the ethers to the contract.
//Checking the insertion of the address into mapping if done successsfully
//Withdrawl function


import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {deploy} from "../script/deployment.s.sol";


contract FundTest is Test{
    FundMe public funds;
    deploy public deployedContract;
    address public dummyUser;
    uint256 public amountToBeTransferred;

    function setUp() public {
        deployedContract = new deploy();
        funds = deployedContract.run();
        dummyUser = vm.addr(1); 
        vm.deal(dummyUser,20e18);    
        amountToBeTransferred = 20e18; 
    }
    
    //Checks the owner [Must Pass]

    // function testOwner() public view {
    //     console.log(msg.sender);
    //     console.log(funds.getOwner());
    //     address owner = msg.sender;
    //     assertEq(funds.getOwner(),owner);
    // }    

    // // Must pass for the wrong owner ( Must be due to a error )
    // function testNotOwner() public {
    //     // vm.prank(dummyUser);
    //     address WrongOwner =  address(this);
    //     console.log(WrongOwner);
    //     console.log(funds.getOwner());
    //     address Owner = funds.getOwner(); 
    //     vm.expectRevert();
    //     assertEq(Owner,WrongOwner);
    // }


    // //Checking funds have been transferred successfully to the contract 
        // vm.prank(dummyUser);

    // function testFunds() public {
    //     funds.fund{value:10e18}();
    //     assertEq(funds.returnBalance(),10e18);
    // }

    //Function should fail in the case if there are insufficient funds.

    // function testReversion() public {
    //     vm.prank(dummyUser);
    //     // uint256 balance = funds.returnBalance(); 
    //     vm.expectRevert();
    //     funds.fund{value:30e18}();
    // }

    // Function should store the address of the person in the array

    // function testStoreAddressInArray() public {
    //     vm.prank(dummyUser);
    //     funds.fund{value:5e18}();
    //     assertEq(funds.getFunder(0),dummyUser);
    // }

    //Function should return the correct amount a person has transferred
    // function testReturnCorrectAmount() public {
    //     vm.prank(dummyUser);
    //     funds.fund{value:5e18}();
    //     address sender = dummyUser;
    //     assertEq(funds.getAddressToAmountFunded(sender),5e18);
    // }

    //Function should fail in returning the false amount a person has not submitted;

    // function testFalseAmountToBeReturned() public {
    //     vm.prank(dummyUser);
    //     funds.fund{value:5e18}();
    //     address sender = dummyUser;
    //     uint256 amount =funds.getAddressToAmountFunded(sender); 
    //     vm.expectRevert();
    //     assertEq(amount,8e18);
    // }

    //Function should fail if a contributor withdraws the amount from the contract 
    // function testOnlyOwner() public {
    //     console.log(msg.sender);
    //     console.log(dummyUser);
    //     vm.prank(dummyUser);
    //     funds.fund{value:7e18}();
    //     vm.expectRevert();
    //     vm.prank(dummyUser);
    //     funds.withdraw();     
    // }

    //Only owner should be able to withdraw the amount from the contract

    // function testOnlyOwnerWithdrawsFund() public {
    //     vm.prank(dummyUser);
    //     funds.fund{value:10e18}();
    //     assertEq(funds.returnBalance(),10e18);
    //     vm.prank(msg.sender);
    //     funds.withdraw();
    //     assertEq(funds.returnBalance(),0);
    // }

    modifier funders{
        
        for (uint160 number = 1; number < 10; number++) {
            address user = vm.addr(number);
            vm.deal(user, amountToBeTransferred);  // Ensure user has the required balance
            vm.prank(user);
            funds.fund{value: amountToBeTransferred}();
    } 
        _;
}

    function testWithdrawlAmount() public  {
        for (uint160 number = 1; number < 10; number++) {
            address user = vm.addr(number);
            vm.deal(user, amountToBeTransferred);  // Ensure user has the required balance
            vm.prank(user);
            funds.fund{value: amountToBeTransferred}();
        } 
            vm.txGasPrice(2);
            uint256 start = gasleft();
            vm.prank(msg.sender);
            funds.cheaperWithdraw();
            uint256 end = gasleft();
            uint256 gasUsed = start-end;
            console.log(start);
            console.log(end);
    }

}