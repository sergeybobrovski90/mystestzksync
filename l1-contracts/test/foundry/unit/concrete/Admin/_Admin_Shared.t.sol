// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";

import {Utils} from "../Utils/Utils.sol";
import {UtilsFacet} from "../Utils/UtilsFacet.sol";

import {AdminFacet} from "solpp/state-transition/chain-deps/facets/Admin.sol";
import {Diamond} from "solpp/state-transition/libraries/Diamond.sol";
import {DiamondInit} from "solpp/state-transition/chain-deps/DiamondInit.sol";
import {DiamondProxy} from "solpp/state-transition/chain-deps/DiamondProxy.sol";
import {FeeParams} from "solpp/state-transition/chain-deps/ZkSyncStateTransitionStorage.sol";
import {IAdmin} from "solpp/state-transition/chain-interfaces/IAdmin.sol";

contract AdminTest is Test {
    IAdmin internal adminFacet;
    UtilsFacet internal utilsFacet;

    function getAdminFacetSelectors() public pure returns (bytes4[] memory selectors) {
        selectors = new bytes4[](10);
        selectors[0] = IAdmin.setPendingGovernor.selector;
        selectors[1] = IAdmin.acceptGovernor.selector;
        selectors[2] = IAdmin.setValidator.selector;
        selectors[3] = IAdmin.setPorterAvailability.selector;
        selectors[4] = IAdmin.setPriorityTxMaxGasLimit.selector;
        selectors[5] = IAdmin.changeFeeParams.selector;
        selectors[6] = IAdmin.upgradeChainFromVersion.selector;
        selectors[7] = IAdmin.executeUpgrade.selector;
        selectors[8] = IAdmin.freezeDiamond.selector;
        selectors[9] = IAdmin.unfreezeDiamond.selector;
    }

    function setUp() public virtual {
        Diamond.FacetCut[] memory facetCuts = new Diamond.FacetCut[](2);
        facetCuts[0] = Diamond.FacetCut({
            facet: address(new AdminFacet()),
            action: Diamond.Action.Add,
            isFreezable: true,
            selectors: getAdminFacetSelectors()
        });
        facetCuts[1] = Diamond.FacetCut({
            facet: address(new UtilsFacet()),
            action: Diamond.Action.Add,
            isFreezable: true,
            selectors: Utils.getUtilsFacetSelectors()
        });

        address diamondProxy = Utils.makeDiamondProxy(facetCuts);
        adminFacet = IAdmin(diamondProxy);
        utilsFacet = UtilsFacet(diamondProxy);
    }
}
