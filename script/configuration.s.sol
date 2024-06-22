//SPDX-License-Identifier:MIT

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {MockV3} from "../test/mocks/AggregatorV3Interface.sol";
contract configure is Script{

    struct network{
        address chain;
    }

    network public tempStruct;
    
    constructor(){
        if(block.chainid==11155111){
            tempStruct = sap();
        }else if(block.chainid==1){
            tempStruct = ethmain();
        }
        else{
            tempStruct = local();
        }
    }

    function sap() public pure returns(network memory){
        network memory temp =  network({
            chain : 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return temp;
    }

    function ethmain () public pure returns(network memory){
        network memory temp = network({
            chain : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return temp;
    }

    function local() public returns(network memory){
        network memory temp;
        if(tempStruct.chain != address(0)){
            return temp;
        }
        vm.startBroadcast();
        MockV3 newMock = new MockV3(8,5e8);       
        vm.stopBroadcast();       
        temp = network({
            chain : address(newMock)
        });
        return temp;
    }

    function getAddress() public view returns(address){
        return tempStruct.chain;
    }
}
