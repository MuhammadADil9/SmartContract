//SPDX-License-Identifier : MIT

pragma solidity ^0.8.20;

import {Test,console} from "forge-std/Test.sol";
import {deploy} from "../script/deployment.s.sol";
import {FundMe} from "../src/FundMe.sol";
import {Fund} from "../script/Integrations.s.sol";
import {withdraw} from "../script/Integrations.s.sol";

contract deployedContract is Test{
    FundMe public fund;
    deploy public dep; 
    withdraw public withdrawCon;
    Fund public fundCon; 
    address public contractAddress;

    function setUp() public {
        dep = new deploy();
        fund = dep.run();
        withdrawCon = new withdraw();
        fundCon = new Fund();
        contractAddress = address(fund);
    }

    

    function testFunding() public  {
        uint256 amount = fund.returnBalance();    
        address WCA = address(withdrawCon);
        // address user = vm.addr(1);
        // uint256 amount = 20e18;
        // vm.deal(user,amount);
        // vm.prank(user);
        // fundCon.run();
        fundCon.fundFund(contractAddress);
        assertEq(fund.returnBalance(),12e18);
        withdrawCon.withdrawl_Function(contractAddress);
        vm.prank(address(this));
        vm.prank(msg.sender);
        assertEq(amount,0);
            
    }


}
