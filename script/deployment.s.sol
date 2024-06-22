//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {configure} from "./configuration.s.sol";

contract deploy is Script {
    function run() external returns(FundMe) {

      configure instance = new configure();
      address chain = instance.getAddress();
      vm.startBroadcast();
      FundMe funds = new FundMe(chain);
      vm.stopBroadcast();
      return funds;
    }
}