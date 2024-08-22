// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Context} from "@openzeppelin-contracts-5.0.2/utils/Context.sol";

contract Penalty is Context {
    uint256 public constant PENALTY_POINTS = 100_000;
    mapping(address => uint256) private penalties;

    function _getPenalty(address contributor) private view returns (uint256) {
        return penalties[contributor];
    }

    function _addPenalty(address contributor) internal {
        penalties[contributor] += PENALTY_POINTS;
    }

    function _compensatePenalty(address contributor, uint256 points) internal returns (uint256 leftoverPoints) {
        uint256 penalty = _getPenalty(contributor);
        if (penalty >= points) {
            leftoverPoints = 0;
            penalties[contributor] -= points;
        } else {
            leftoverPoints = points - penalty;
            penalties[contributor] = 0;
        }
    }
}
