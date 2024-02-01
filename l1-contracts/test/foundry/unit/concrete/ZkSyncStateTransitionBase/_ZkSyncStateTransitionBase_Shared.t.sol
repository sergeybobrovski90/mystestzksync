// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";

import {Utils} from "../Utils/Utils.sol";
import {UtilsFacet} from "../Utils/UtilsFacet.sol";

import {Diamond} from "solpp/state-transition/libraries/Diamond.sol";
import {ZkSyncStateTransitionBase} from "solpp/state-transition/chain-deps/facets/Admin.sol";

contract TestBaseFacet is ZkSyncStateTransitionBase {
    function functionWithOnlyGovernorModifier() external onlyGovernor {}

    function functionWithOnlyValidatorModifier() external onlyValidator {}

    function functionWithOnlyStateTransitionManagerModifier() external onlyStateTransitionManager {}

    function functionWithOnlyBridgehubModifier() external onlyBridgehub {}

    function functionWithOnlyGovernorOrStateTransitionManagerModifier() external onlyGovernorOrStateTransitionManager {}
}

bytes constant ERROR_ONLY_GOVERNOR = "StateTransition Chain: not governor";
bytes constant ERROR_ONLY_VALIDATOR = "StateTransition Chain: not validator";
bytes constant ERROR_ONLY_STATE_TRANSITION_MANAGER = "StateTransition Chain: not state transition manager";
bytes constant ERROR_ONLY_BRIDGEHUB = "StateTransition Chain: not bridgehub";
bytes constant ERROR_ONLY_GOVERNOR_OR_STATE_TRANSITION_MANAGER = "StateTransition Chain: Only by governor or state transition manager";

contract ZkSyncStateTransitionBaseTest is Test {
    TestBaseFacet internal testBaseFacet;
    UtilsFacet internal utilsFacet;

    function getTestBaseFacetSelectors() public pure returns (bytes4[] memory selectors) {
        selectors = new bytes4[](5);
        selectors[0] = TestBaseFacet.functionWithOnlyGovernorModifier.selector;
        selectors[1] = TestBaseFacet.functionWithOnlyValidatorModifier.selector;
        selectors[2] = TestBaseFacet.functionWithOnlyStateTransitionManagerModifier.selector;
        selectors[3] = TestBaseFacet.functionWithOnlyBridgehubModifier.selector;
        selectors[4] = TestBaseFacet.functionWithOnlyGovernorOrStateTransitionManagerModifier.selector;
    }

    function setUp() public virtual {
        Diamond.FacetCut[] memory facetCuts = new Diamond.FacetCut[](2);
        facetCuts[0] = Diamond.FacetCut({
            facet: address(new TestBaseFacet()),
            action: Diamond.Action.Add,
            isFreezable: true,
            selectors: getTestBaseFacetSelectors()
        });
        facetCuts[1] = Diamond.FacetCut({
            facet: address(new UtilsFacet()),
            action: Diamond.Action.Add,
            isFreezable: true,
            selectors: Utils.getUtilsFacetSelectors()
        });

        address diamondProxy = Utils.makeDiamondProxy(facetCuts);
        testBaseFacet = TestBaseFacet(diamondProxy);
        utilsFacet = UtilsFacet(diamondProxy);
    }
}