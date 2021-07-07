// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "./../interfaces/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract SwapProxy is Ownable {

    struct SwapDescription {
        IERC20 srcToken;
        IERC20 dstToken;
        address srcReceiver;
        address dstReceiver;
        uint256 amount;
        uint256 minReturnAmount;
        uint256 flags;
        bytes permit;
    }

    address immutable AGGREGATION_ROUTER_V3;

    constructor(address router) {
        AGGREGATION_ROUTER_V3 = router;
    }

    function swap(uint minOut, bytes calldata _data) external onlyOwner {
        (address _c, SwapDescription memory desc, bytes memory _d) = abi.decode(_data[4:], (address, SwapDescription, bytes));

        IERC20(desc.srcToken).transferFrom(msg.sender, address(this), desc.amount);
        IERC20(desc.srcToken).approve(AGGREGATION_ROUTER_V3, desc.amount);

        (bool succ, bytes memory _data) = address(AGGREGATION_ROUTER_V3).call(_data);
        if (succ) {
            (uint returnAmount, uint gasLeft) = abi.decode(_data, (uint, uint));
            require(returnAmount >= minOut);
        } else {
            revert();
        }
    }
}