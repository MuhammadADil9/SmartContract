//SPDX-License-Identifier:MIT

pragma solidity ^0.8.24;
// import {Script} from "forge-std/Script.sol";
// import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
// import {FundMe} from "../src/FundMe.sol";


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