// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {AdminTest} from "./_Admin_Shared.t.sol";
import {ERROR_ONLY_GOVERNOR_OR_STATE_TRANSITION_MANAGER} from "../ZkSyncStateTransitionBase/_ZkSyncStateTransitionBase_Shared.t.sol";

contract FreezeDiamondTest is AdminTest {
    event Freeze();

    function test_revertWhen_calledByNonGovernorOrStateTransitionManager() public {
        address nonGovernorOrStateTransitionManager = makeAddr("nonGovernorOrStateTransitionManager");

        vm.expectRevert(ERROR_ONLY_GOVERNOR_OR_STATE_TRANSITION_MANAGER);

        vm.startPrank(nonGovernorOrStateTransitionManager);
        adminFacet.freezeDiamond();
    }

    // function test_revertWhen_diamondIsAlreadyFrozen() public {
    //     address governor = utilsFacet.util_getGovernor();

    //     utilsFacet.util_setIsFrozen(true);

    //     vm.expectRevert(bytes.concat("a9"));

    //     vm.startPrank(governor);
    //     adminFacet.freezeDiamond();
    // }

    // function test_successfulFreeze() public {
    //     address governor = utilsFacet.util_getGovernor();

    //     utilsFacet.util_setIsFrozen(false);

    //     vm.expectEmit(true, true, true, true, address(adminFacet));
    //     emit Freeze();

    //     vm.startPrank(governor);
    //     adminFacet.freezeDiamond();

    //     assertEq(utilsFacet.util_getIsFrozen(), true);
    // }
}
