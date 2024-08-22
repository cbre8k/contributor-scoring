// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "./Migrate.s.sol";
import {Roles} from "../src/libraries/Roles.sol";
import {Contributor} from "../src/Contributor.sol";
import {AccessManager} from "../src/AccessManager.sol";

contract Deployer is BaseMigrate {
    function run() external {
        deploy();
    }

    function deploy() public broadcast {
        address manager = address(deployContract("AccessManager.sol:AccessManager", abi.encode()));
        deployContract("Contributor.sol:Contributor", abi.encode(manager));
    }
}
