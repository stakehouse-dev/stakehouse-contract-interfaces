pragma solidity ^0.8.10;

import { IDataStructures } from './IDataStructures.sol';

// SPDX-License-Identifier: BUSL-1.1

interface IFullWithdrawals {
    /// @dev View mapping methods
    function isFullSweepReported(uint256 _withdrawalIndex) external view returns (bool);
    function finalSweepAmountReportedForBlsPublicKey(bytes calldata) external view returns (uint256);

    /// @notice After the withdrawal epoch of a validator has been reached, allow the final sweep to be reported to claim unstaked ETH
    /// @param _totalETHSentToBLSKey Total amount of ETH sent to the Ethereum deposit contract for a given BLS public key
    /// @param _blsPublicKey From which a full unstaking withdrawal is taking place
    /// @param _unreportedSweeps List of sweeps that were not reported for the BLS key to check if there is amount of unreported ETH swept that needs to be paid out
    /// @param _finalSweep Final sweep that was generated after the withdrawal epoch was reached
    /// @param _beaconChainReport Validator state information from the beacon chain
    /// @param _signature over the reports allowing the withdrawal to take place
    function reportFinalSweepAndWithdraw(
        uint256 _totalETHSentToBLSKey,
        bytes calldata _blsPublicKey,
        IDataStructures.Sweep[] calldata _unreportedSweeps,
        IDataStructures.SweepWithSlotInfo calldata _finalSweep,
        IDataStructures.ETH2DataReport calldata _beaconChainReport,
        IDataStructures.EIP712Signature calldata _signature
    ) external;
}