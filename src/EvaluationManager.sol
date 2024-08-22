// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Points} from "./Points.sol";
import {EnumerableSet} from "@openzeppelin-contracts-5.0.2/utils/structs/EnumerableSet.sol";

contract EvaluationManager is Points {
    using EnumerableSet for *;

    event EvalSessionOpened(uint256 epoch);
    event EvalSessionClosed(uint256 epoch);
    event Evaluated(address evaluator, uint256 epoch);

    struct Evaluation {
        bytes32 poe;
        uint128 openAt;
        uint128 closeAt;
        EnumerableSet.AddressSet evaluators;
        mapping(uint256 => uint256) score;
    }

    uint256 public epoch;
    mapping(uint256 => Evaluation) private evaluations;

    function _isEvaluated(address contributor_) internal view returns (bool) {
        return evaluations[epoch].evaluators.contains(contributor_);
    }

    function _numOfEvaluators() internal view returns (uint256) {
        return evaluations[epoch].evaluators.length();
    }

    function _getPoints(uint256 slot) internal view returns (uint256) {
        return evaluations[epoch].score[slot];
    }

    function _open(bytes32 poe_) internal {
        if (epoch != 0) {
            _close(epoch);
        }
        epoch += 1;
        Evaluation storage eval = evaluations[epoch];
        eval.poe = poe_;
        eval.openAt = uint128(block.timestamp);

        emit EvalSessionOpened(epoch);
    }

    function _evaluate(uint256[] calldata points_) internal {
        address sender = _msgSender();

        Evaluation storage eval = evaluations[epoch];
        require(!eval.evaluators.contains(sender), "already evaluated");

        for (uint256 i; i < points_.length; ++i) {
            eval.score[i] += points_[i];
        }
        eval.evaluators.add(sender);

        emit Evaluated(sender, epoch);
    }

    function _close(uint256 epoch_) internal {
        _penalize();
        _finalize();
        evaluations[epoch_].closeAt = uint128(block.timestamp);
        emit EvalSessionClosed(epoch_);
    }

    function _penalize() internal virtual {}
    function _finalize() internal virtual {}
}
