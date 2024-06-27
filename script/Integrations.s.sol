//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;
import {Script,console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
// ../lib/foundry-devops/src/DevOpsTools.sol

contract Fund is Script {
    
    uint256 private constant amount = 12e18;

    function fundFund(address ContractAddress) public {
        vm.startBroadcast();
        FundMe(ContractAddress).fund{value:amount}("User");
        vm.stopBroadcast();
        console.log("Transaction Done Successfully");
    }

    function run() external {

        address LatestAddress = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        fundFund(LatestAddress);

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