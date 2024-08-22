// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "@forge-std-1.9.1/src/Test.sol";
import {Roles} from "../src/libraries/Roles.sol";
import {Contributor} from "../src/Contributor.sol";
import {AccessManager} from "../src/AccessManager.sol";
import {EvaluationManager} from "../src/EvaluationManager.sol";

contract ContributorTest is Test {
    AccessManager manager;
    Contributor contributor;

    address admin;
    address a;
    address b;
    address c;

    function setUp() public {
        admin = makeAddr("admin");
        a = makeAddr("a");
        b = makeAddr("b");
        c = makeAddr("c");

        vm.startPrank(admin);
        manager = new AccessManager();
        manager.grantRole(Roles.CONTRIBUTOR_ROLE, a);
        manager.grantRole(Roles.CONTRIBUTOR_ROLE, b);
        manager.grantRole(Roles.CONTRIBUTOR_ROLE, c);

        contributor = new Contributor(address(manager));
        vm.stopPrank();
    }

    function testOpenEvalSuccess() public {
        vm.expectEmit();
        emit EvaluationManager.EvalSessionOpened(1);
        _open();
    }

    function testSingleEvaluateSuccess() public {
        _open();
        vm.expectEmit();
        emit EvaluationManager.Evaluated(a, 1);
        _evaluatedBy(a, _getPoints(7, 8, 9));
    }

    function testMultipleEvaluateSuccess() public {
        _open();
        _evaluatedBy(a, _getPoints(7, 8, 9));
        _evaluatedBy(b, _getPoints(9, 8, 7));
        _open();

        vm.prank(a);
        assertEq(contributor.getPoints(), 80_000);
        vm.prank(b);
        assertEq(contributor.getPoints(), 80_000);
        vm.prank(c);
        assertEq(contributor.getPoints(), 0);
    }

    function _open() internal {
        vm.prank(admin);
        contributor.openEvaluationSession(keccak256("adidas"));
    }

    function _evaluatedBy(address contributor_, uint256[] memory points_) internal {
        vm.prank(contributor_);
        contributor.evaluate(points_);
    }

    function _getPoints(uint256 a_, uint256 b_, uint256 c_) internal view returns (uint256[] memory points) {
        points = new uint256[](3);
        points[0] = a_;
        points[1] = b_;
        points[2] = c_;
    }
}
