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


error TargetAchieved(uint256 ContractBalance,uint256 SenderAmount);

contract FundTest is Test{
    FundMe public funds;
    deploy public deployedContract;
    address public dummyUser;
    uint256 public amountToBeTransferred;

    function setUp() public {
        deployedContract = new deploy();
        funds = deployedContract.run();
        dummyUser = vm.addr(1); 
        amountToBeTransferred = 80e18; 
        vm.deal(dummyUser,amountToBeTransferred);    
    }
    
    // Checks the right owner
    function testTrueOwner() public view returns(address){
        address owner = funds.getOwner();
        assertEq(owner,msg.sender);
    }

    // True for false owner
    function testFalseOwner() public {
        address owner = funds.getOwner();
        vm.expectRevert();
        assertEq(owner,dummyUser);
    }


    //Amount getting stored in the contract sended by the user

    function testTransferFund() public {
        uint256 ContractInitialBalance = funds.returnBalance();
        // uint256 UserBalance = 20e18;
        vm.prank(dummyUser);
        funds.fund{value:20e18}("arslan");
        uint256 ContractFinalBalance = funds.returnBalance();
        assertEq(20e18,ContractFinalBalance);
        assertEq(ContractInitialBalance,0);
    }

    //Amount gets rejected if the balance exceeds 50 ETH

    function testFundsDoesNotExceedLimit() public {
        //sends 48 ETH in first round of transactions
        vm.prank(dummyUser);
        uint256 bal = funds.returnBalance();
        console.log(bal);
        funds.fund{value:48e18}("arslan");
        uint256 ContractBalance1stIteration = funds.returnBalance();
        console.log(ContractBalance1stIteration);

        //sends 5 ETH in second round of transactions
        vm.prank(dummyUser);
        try funds.fund{value:5e18}("arslan"){
            console.log("Transcation happened successfully.");
        }catch (bytes memory reason) {
            
            //extracing the error selector from the data which is merged along the other abi.encoded data(arguments)
            //Mathes it with the error selector in the test
            bytes4 selector;
            assembly{
                selector := mload(add(reason,0x40))
            }
            if(selector == TargetAchieved.selector){
                console.log("Error is same");
            }
        }

        uint256 ball = funds.returnBalance();
        console.log(ball);
    }



// Username should get store in the mapping 

    function testUserNameStoredInMapping() public {
        vm.prank(dummyUser);
        funds.fund{value:25e18}("arslan");
        (string memory fName, uint256 fAmount ) =  funds.getFunderDetail(0);
        assertEq("arslan",fName);
        assertEq(25e18,fAmount);
    }

// Must be true for false user name

    function testRejectFalseNameToBePresentInMapping() public {
        
        vm.prank(dummyUser);
        funds.fund{value:25e18}("arslan");
        (string memory fName, uint256 fAmount ) =  funds.getFunderDetail(0);
        string memory SenderName = "arslan";
        vm.expectRevert();
        assertEq(SenderName,"Bilal");
    }

    function testWithdraw() public {
        uint256 i_cBalance = funds.returnBalance();
        uint256 i_oBalance = funds.getOwnerBalance();

        vm.prank(dummyUser);
        funds.fund{value:25e18}("arslan");
        vm.prank(dummyUser);
        funds.fund{value:15e18}("arslan");
        
        vm.prank(msg.sender);
        funds.withdraw();

        uint256 f_cBalance = funds.returnBalance();
        uint256 f_oBalance = funds.getOwnerBalance();

        // console.log(f_oBalance);
        console.log(f_cBalance);
        // uint256 am = msg.sender.balance;

        // assertEq(am,40e18);
        assertEq(i_cBalance,0);
        assertEq(f_cBalance,0);

    }

    
    function testCheapWithdraw() public {
        uint256 i_cBalance = funds.returnBalance();
        uint256 i_oBalance = funds.getOwnerBalance();

        vm.prank(dummyUser);
        funds.fund{value:25e18}("arslan");
        vm.prank(dummyUser);
        funds.fund{value:15e18}("arslan");
        
        vm.prank(msg.sender);
        funds.cheaperWithdraw();

        uint256 f_cBalance = funds.returnBalance();
        uint256 f_oBalance = funds.getOwnerBalance();

        // console.log(f_oBalance);
        console.log(f_cBalance);
        // uint256 am = msg.sender.balance;

        // assertEq(am,40e18);
        assertEq(i_cBalance,0);
        assertEq(f_cBalance,0);

    }


    function testHighestContribution() public  {
        address a = vm.addr(2);
        address b = vm.addr(3);
        address c = vm.addr(4);
        address d = vm.addr(5);

        vm.deal(a,6e18);
        vm.deal(b,15e18);
        vm.deal(c,20e18);
        vm.deal(d,9e18);

        vm.prank(a);
        funds.fund{value:6e18}("Arslan");

        vm.prank(b);
        funds.fund{value:15e18}("Jhanzeb");

        vm.prank(c);
        funds.fund{value:20e18}("Bilal");

        vm.prank(d);
        funds.fund{value:8e18}("Daniyal");
    
        (string memory name,uint256 amount) = funds.HighestContribution();
        
        assertEq(name,"Bilal");
        assertEq(amount,20e18);
        
    }

    function testgetOwnerBalance() public {
        uint256 bal = funds.returnBalance();
        assertEq(bal,0);
    }

    function testVersion() public {
        uint256 version = funds.getVersion();
        assertEq(version,4);

    }
}













//     //Checks the owner [Must Pass]

//     // function testOwner() public view {
//     //     console.log(msg.sender);
//     //     console.log(funds.getOwner());
//     //     address owner = msg.sender;
//     //     assertEq(funds.getOwner(),owner);
//     // }    

//     // // Must pass for the wrong owner ( Must be due to a error )
//     // function testNotOwner() public {
//     //     // vm.prank(dummyUser);
//     //     address WrongOwner =  address(this);
//     //     console.log(WrongOwner);
//     //     console.log(funds.getOwner());
//     //     address Owner = funds.getOwner(); 
//     //     vm.expectRevert();
//     //     assertEq(Owner,WrongOwner);
//     // }


//     // //Checking funds have been transferred successfully to the contract 
//         // vm.prank(dummyUser);

//     // function testFunds() public {
//     //     funds.fund{value:10e18}();
//     //     assertEq(funds.returnBalance(),10e18);
//     // }

//     //Function should fail in the case if there are insufficient funds.

//     // function testReversion() public {
//     //     vm.prank(dummyUser);
//     //     // uint256 balance = funds.returnBalance(); 
//     //     vm.expectRevert();
//     //     funds.fund{value:30e18}();
//     // }

//     // Function should store the address of the person in the array

//     // function testStoreAddressInArray() public {
//     //     vm.prank(dummyUser);
//     //     funds.fund{value:5e18}();
//     //     assertEq(funds.getFunder(0),dummyUser);
//     // }

//     //Function should return the correct amount a person has transferred
//     // function testReturnCorrectAmount() public {
//     //     vm.prank(dummyUser);
//     //     funds.fund{value:5e18}();
//     //     address sender = dummyUser;
//     //     assertEq(funds.getAddressToAmountFunded(sender),5e18);
//     // }

//     //Function should fail in returning the false amount a person has not submitted;

//     // function testFalseAmountToBeReturned() public {
//     //     vm.prank(dummyUser);
//     //     funds.fund{value:5e18}();
//     //     address sender = dummyUser;
//     //     uint256 amount =funds.getAddressToAmountFunded(sender); 
//     //     vm.expectRevert();
//     //     assertEq(amount,8e18);
//     // }

//     //Function should fail if a contributor withdraws the amount from the contract 
//     // function testOnlyOwner() public {
//     //     console.log(msg.sender);
//     //     console.log(dummyUser);
//     //     vm.prank(dummyUser);
//     //     funds.fund{value:7e18}();
//     //     vm.expectRevert();
//     //     vm.prank(dummyUser);
//     //     funds.withdraw();     
//     // }

//     //Only owner should be able to withdraw the amount from the contract

//     // function testOnlyOwnerWithdrawsFund() public {
//     //     vm.prank(dummyUser);
//     //     funds.fund{value:10e18}();
//     //     assertEq(funds.returnBalance(),10e18);
//     //     vm.prank(msg.sender);
//     //     funds.withdraw();
//     //     assertEq(funds.returnBalance(),0);
//     // }

//     modifier funders{
        
//         for (uint160 number = 1; number < 10; number++) {
//             address user = vm.addr(number);
//             vm.deal(user, amountToBeTransferred);  // Ensure user has the required balance
//             vm.prank(user);
//             funds.fund{value: amountToBeTransferred}();
//     } 
//         _;
// }

//     function testWithdrawlAmount() public  {
//         for (uint160 number = 1; number < 10; number++) {
//             address user = vm.addr(number);
//             vm.deal(user, amountToBeTransferred);  // Ensure user has the required balance
//             vm.prank(user);
//             funds.fund{value: amountToBeTransferred}();
//         } 
//             vm.txGasPrice(2);
//             uint256 start = gasleft();
//             vm.prank(msg.sender);
//             funds.cheaperWithdraw();
//             uint256 end = gasleft();
//             uint256 gasUsed = start-end;
//             console.log(start);
//             console.log(end);
//     }

