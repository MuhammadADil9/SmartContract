//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;
import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
import {configure} from "./configuration.s.sol";

// ../lib/foundry-devops/src/DevOpsTools.sol

contract Fund is Script {
    
    FundMe private fundFundContract;
    uint256 private constant amount = 12e18;


    function fundFund(address ContractAddress) public {

        vm.startBroadcast();
        FundMe(ContractAddress).fund{value:amount}("User");
        vm.stopBroadcast();
        console.log("Transaction Done Successfully");
    
    }



    // function run() external {
     
    //  configure instance = new configure();
    //  address chain = instance.getAddress();

    //     vm.startBroadcast();
    //     fundFundContract = new FundMe(chain); 
    //     vm.stopBroadcast();
    //     // address LatestAddress = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
    //     // fundFund(LatestAddress);
    // address ContractAddress = address(fundFundContract); 
    // fundFund(ContractAddress);
    // }

}



contract withdraw is Script{
    FundMe private funder;
    
    function withdrawl_Function(address ContractAddress) public {
        funder = FundMe(ContractAddress); 
        funder.withdraw();
    }

}





// contract fundContract is Script {
    

//     function FundFundContract() public {
//         FundMe  Fund;
//         address user = vm.addr(1);
//         uint256 amount = 10e18;
//         vm.deal(user,amount);
        
//         address ContracrAddress = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
//         Fund = FundMe(ContracrAddress);

//         vm.prank(user);

//         vm.startBroadcast();
//         Fund.fund{value:7e18}();
//         vm.stopBroadcast();
//     }
// }

// contract withdrawFunds{

// function withdraw() public {
//         FundMe Fund;
//         address ContracrAddress = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
//         Fund = FundMe(ContracrAddress);

//         vm.startBroadcast();
//         Fund.withdraw();
//         vm.stopBroadcast();
//     }

// }