// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Penalty} from "./Penalty.sol";

contract Points is Penalty {
    uint256 constant public DENOMINATOR = 10_000;
    mapping(address => uint256) private contribPts;

    function getPoints() external virtual view returns (uint256) {
        return contribPts[_msgSender()];
    }

    function _updatePoints(address contributor, uint256 avgPts) internal {
        uint256 finalizePts = _compensatePenalty(contributor, avgPts);
        contribPts[contributor] += finalizePts;
    }
}
