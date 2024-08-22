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
        for (uint256 i; i < getRoleMemberCount(Roles.CONTRIBUTOR_ROLE); ++i) {
            contributors[i] = getRoleMember(Roles.CONTRIBUTOR_ROLE, i);
        }
    }
}
