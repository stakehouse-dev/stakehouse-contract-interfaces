pragma solidity ^0.8.10;

// SPDX-License-Identifier: BUSL-1.1

interface IRageQuitAssistantDeployer {
    function isAssistantDeployed(address) external view returns (bool);
    function rageQuitAssistantForBlsPublicKey(bytes calldata _blsPublicKey) external view returns (address);

    /// @notice Deploy a new rage quit assistant on demand from this factory
    /// @param _feesAndMevPool Set this to address zero if the BLS key is a Stakehouse protocol validator. Otherwise if its a LSD validator set this as required.
    function deployAssistant(address _feesAndMevPool, bytes calldata _blsPublicKey) external override returns (address);
}