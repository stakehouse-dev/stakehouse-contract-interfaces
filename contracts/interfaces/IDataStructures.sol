pragma solidity ^0.8.10;

// SPDX-License-Identifier: BUSL-1.1

interface IDataStructures {
    /// @dev Data structure used for ETH2 data reporting
    struct ETH2DataReport {
        bytes blsPublicKey; /// Public key of the validator
        bytes withdrawalCredentials; /// Withdrawal credentials submitted to the beacon chain
        bool slashed; /// Slashing status
        uint64 activeBalance; /// Validator active balance
        uint64 effectiveBalance; /// Validator effective balance
        uint64 exitEpoch; /// Exit epoch of the validator
        uint64 activationEpoch; /// Activation Epoch of the validator
        uint64 withdrawalEpoch; /// Withdrawal Epoch of the validator
        uint64 currentCheckpointEpoch; /// Epoch of the checkpoint during data reporting
    }

    /// @dev Signature over the hash of essential data
    struct EIP712Signature {
        // we are able to pack these two unsigned ints into a
        uint248 deadline; // deadline defined in ETH1 blocks
        uint8 v; // signature component 1
        bytes32 r; // signature component 2
        bytes32 s; // signature component 3
    }

    /// @dev Data Structure used for Accounts
    struct Account {
        address depositor; /// ECDSA address executing the deposit
        bytes blsSignature; /// BLS signature over the SSZ "DepositMessage" container
        uint256 depositBlock; /// Block During which the deposit to EF Deposit Contract was completed
    }

    struct Sweep {
        // Sweeps can be reported out of order apart from validators part of the set pre-shanghai
        uint256 withdrawalIndex;
        uint256 validatorIndex;
        address recipient;
        uint256 amount;
    }

    // Sweep payload but decorated with SLOT information so that we can check if it's after the withdrawal SLOT
    struct SweepWithSlotInfo {
        Sweep sweep;
        uint256 slot;
        uint256 block;
    }

    struct ShanghaiReport {
        address stakeHouse;           /// Address of the Stakehouse of the associated BLS public key being reported
        bytes blsPublicKey;           /// BLS public key of the validator from which the sweep originated
        uint256 totalETHSentToBLSKey; /// Total sum of all ETH ever sent to the Ethereum deposit contract for the given BLS public key
        uint256 sumOfAllSweeps;       /// Total sum of all sweeps being reported within this transaction which may be less than total ever swept
        Sweep[] sweeps;               /// List of sweeps being reported in this transaction which will sum up to `sumOfAllSweeps`
    }

    /// @dev lifecycle status enumeration of the user
    enum LifecycleStatus {
        UNBEGUN,
        INITIALS_REGISTERED,
        DEPOSIT_COMPLETED,
        TOKENS_MINTED,
        EXITED,
        UNSTAKED
    }
}
