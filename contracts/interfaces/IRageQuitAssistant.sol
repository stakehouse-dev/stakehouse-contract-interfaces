pragma solidity ^0.8.10;

// SPDX-License-Identifier: BUSL-1.1

import { IDataStructures } from './IDataStructures.sol';

interface IRageQuitAssistant {

    /// @notice Initialisation triggered when the rage quit assistant is deployed collecting all of the information required to rage quit
    function init(address, bytes calldata _blsPublicKey) external;

    /// @notice Address of the rage quit LPs will receive in exchange for supplying dETH
    function dETHRageQuitLP() external view returns (address);

    /// @notice Address of the rage quit LPs will receive in exchange for supplying sETH
    function sETHRageQuitLP() external view returns (address);

    /// @notice Total dETH deposited by outside LPs for rage quit
    function totalDETHDeposited() external view returns (uint256);

    /// @notice Total sETH deposited by outside LPs for rage quit
    function totalSETHDeposited() external view returns (uint256);

    /// @notice Smart wallet rage quitting needs to have savETH isolated to this index as per rage quit rule
    function savETHIndexIdOwnedBySmartWalletRageQuitting() external view returns (uint256);

    /// @notice At the time of rage quit, how much dETH was consumed which may be less than `totalDETHDeposited`
    function dETHConsumedFromAssistantAtTimeOfRageQuit() external view returns (uint256);

    /// @notice Address of the sETH token for the LSD house associated with the BLS public key being rage quit
    function sETHTokenForLSDHouse() external view returns (address);

    /// @notice Whether the Stakehouse protocol account manager has paid the rage quit assistant unstaked ETH
    function isFullWithdrawalExecuted() external view returns (bool);

    /// @notice BLS public key of validator being rage quit
    function blsPublicKey() external view returns (bytes memory);

    /// @notice Distribute any ETH received from rage quit amongst all LPs that supplied the Stakehouse protocol assets for rage quit
    function distributeETH() external;

    /// @notice Considering the original 4 ETH principle for collateralised slot, how much is claimable based on the final sweep amount
    function getCollateralisedSlotClaimableAmount() external view returns (uint256 claimable, uint256 totalErrosionOfPrincipleBalance);

    /// @notice Considering the original 4 ETH principle for free floating slot, how much is claimable based on the final sweep amount
    function getFreeFloatingSlotClaimableAmount() external view returns (
        uint256 claimable,
        uint256 differenceVersusMaxClaimable
    );

    /// @notice Preview how much additional claimable amount of ETH is available per ETH of debt deposited by each LP
    function previewDistributeETH() external view returns (
        uint256 totalETHReceived,
        uint256 additionalETHSinceLastCall,
        uint256 additionalClaimableAmountPerETHOfPrincipleDeposit,
        uint256 totalTopUps,
        uint256 totalUnknownTopUps,
        uint256 inflation
    );

    /// @notice Function for depositing dETH into this contract for the purposes of rage quitting a BLS public key to receive ETH 1:1 from a full withdrawal
    /// @dev The node operator can then meet the requirements of the stakehouse protocol whilst dETH holders get to receive ETH 1:1 slippage free
    /// @param _amount The amount the user is depositing
    function dETHDeposit(uint256 _amount) external;

    /// @notice Allow a rage quit LP user to withdraw dETH from the contract before and after rage quit.
    /// @dev No lifecycle checks since even if rage quit has happened, in most cases there will be no dETH or some leftover so we should allow it to be taken
    /// @param _amount The Amount of rage quit LP token the user is burning
    function dETHWithdrawal(uint256 _amount) external;

    /// @notice Function for depositing sETH into this contract for the purposes of rage quitting a BLS public key
    /// @param _amount The amount the user is depositing
    function sETHDeposit(uint256 _amount) external;

    /// @notice Function for withdrawing sETH deposited to the contract before rage quitting
    /// @param _amount The Amount of rage quit LP token the user is burning
    function sETHWithdrawal(uint256 _amount) external;

    /// @notice Allow the rage quit assistant to perform preparation steps to be rage quit compliant with the stakhouse protocol including ensuring savETH isolation rule is met
    /// @dev Only the liquid staking manager of an LSD or transaction router can call. The idea is for this to be called immediately before the rage quit so that if any part of the TX fails, the funds are returned without issue or delay
    function prepareRageQuit() external;

    /// @notice As a dETH LP, allow claiming ETH received from unstaking on the basis of how much dETH the user owns
    /// @param _amount The Amount of rage quit LP token the user is burning
    function dETHClaim(uint256 _amount) external;

    /// @notice As a sETH LP, allow claiming ETH received from unstaking on the basis of how much sETH the user owns
    /// @dev If the final sweep was less than 28 ETH (more than 4 ETH lost), this will eat into the amount of ETH that can be claimed
    /// @param _amount The Amount of rage quit LP token the user is burning
    function sETHClaim(uint256 _amount) external;

    /// @notice Allow the LSD node operator or ZEC council to claim the correct amount of ETH from rage quitting
    function nodeOperatorClaim() external;

    /// @notice Allow the other collateralised slot owners to claim unstaked ETH if they topped up slot whilst it was active
    /// @param _index related to the collateralisedBalancesAtRageQuit array
    function collateralisedSlotOwnerClaim(uint256 _index) external;

    /// @notice As the recipient of rage quit funds, the contract must request the full withdrawal of ETH from the account manager after consensus layer has processed the withdrawal
    /// @dev Full withdrawals contract will ensure that this can only be executed once
    function executeFullWithdrawal(
        uint256 _totalETHSentForBLSKey,
        IDataStructures.Sweep[] calldata _unreportedSweeps,
        IDataStructures.SweepWithSlotInfo calldata _finalSweep,
        IDataStructures.ETH2DataReport calldata _beaconChainReport,
        IDataStructures.EIP712Signature calldata _signature
    ) external;

    /// @notice Historical amount of ETH sent to this smart contract
    function totalETHReceivedFromRageQuit() external view returns (uint256);

    /// @notice Total dETH required to perform the isolation job that is a pre-condition for rage quit
    function dETHRequiredForIsolation() external view returns (uint256);

    /// @notice Once unstaked from consensus layer, how much a dETH LP will receive as a pro-rata share
    function dETHClaimPreview(address _lp, uint256 _amount) external view returns (uint256);

    /// @notice Once unstaked from consensus layer, how much a sETH LP will receive as a pro-rata share
    function sETHClaimPreview(address _lp, uint256 _amount) external view returns (uint256);

    /// @notice Once unstaked from consensus layer, how much a node operator (first collateralised slot owner) will receive
    function nodeOperatorClaimPreview(address _operator) external view returns (uint256);

    /// @notice The size of the collateralised slot owner balance snapshot at the time of rage quit
    function collateralisedBalancesAtRageQuitLength() external view returns (uint256);
}
