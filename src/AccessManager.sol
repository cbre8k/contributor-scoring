// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Roles} from "./libraries/Roles.sol";
import {AccessControlEnumerable} from "@openzeppelin-contracts-5.0.2/access/extensions/AccessControlEnumerable.sol";

interface IAccessManager {
    function getContributors() external view returns (address[] memory);
}

contract AccessManager is IAccessManager, AccessControlEnumerable {
    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function getContributors() external view returns (address[] memory contributors) {
        uint256 contributorCount = getRoleMemberCount(Roles.CONTRIBUTOR_ROLE);
        contributors = new address[](contributorCount);

        for (uint256 i = 0; i < contributorCount; ++i) {
            contributors[i] = getRoleMember(Roles.CONTRIBUTOR_ROLE, i);
        }
    }
}
