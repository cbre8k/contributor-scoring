// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Roles} from "./libraries/Roles.sol";
import {AccessManager} from "./AccessManager.sol";
import {EvaluationManager} from "./EvaluationManager.sol";

contract Contributor is EvaluationManager {
    AccessManager public manager;

    constructor(address manager_) {
        manager = AccessManager(manager_);
    }

    modifier onlyRole(bytes32 role) {
        require(manager.hasRole(role, _msgSender()), "unauthorized");
        _;
    }

    function openEvaluationSession(bytes32 poe_) external onlyRole(manager.DEFAULT_ADMIN_ROLE()) {
        _open(poe_);
    }

    function evaluate(uint256[] calldata points_) external onlyRole(Roles.CONTRIBUTOR_ROLE) {
        _evaluate(points_);
    }

    function _penalize() internal override {
        address[] memory contributors = manager.getContributors();

        address contributor;
        for (uint256 i; i < contributors.length; ++i) {
            contributor = contributors[i];
            if (!_isEvaluated(contributor)) {
                _addPenalty(contributor);
            }
        }
    }

    function _finalize() internal override {
        uint256 avgPts;
        address contributor;
        address[] memory contributors = manager.getContributors();

        for (uint256 i; i < contributors.length; ++i) {
            contributor = contributors[i];
            avgPts = (_getPoints(i) * DENOMINATOR / _numOfEvaluators());
            _updatePoints(contributor, avgPts);
        }
    }
}
