pragma solidity ^0.8.13;

// SPDX-License-Identifier: MIT

interface ISafeBox {
    /// @notice Signal about the guardian giving up its duties
    event GuardianRelinquished(address indexed guardian);

    /// @notice Event to signal adding new guardian
    event GuardianAdded(
        address indexed guardianAddress,
        bytes aesPublicKey,
        uint guardianIndexPointer
    );

    /// @notice Submit decryption information
    event DecryptionSubmitted(
        address guardian,
        bytes recipientAesKey,
        bytes blsPublicKey,
        bytes ciphertext,
        bytes zkProof,
        uint256 nonce
    );

    /// @notice Notify network about submitted decryption request
    event DecryptionRequestSubmitted(
        address[] requester,
        bytes knotId,
        uint256 nonce,
        address stakehouse,
        bytes aesPublicKey
    );

    /// @notice Event to signal reencryption update
    event ReEncryptionUpdate(
        bytes knotId,
        bytes ciphertext,
        bytes aesEncryptorKey
    );

    /// @notice Send application for the signing key to be decrypted
    /// @param _knotId - BLS public key of the knot
    /// @param _stakehouse - Stakehouse address knot belongs to
    /// @param _aesPublicKey - Public key decrypting the ciphertext
    function applyForDecryption(
        bytes calldata _knotId,
        address _stakehouse,
        bytes calldata _aesPublicKey
    ) external;

    /// @notice Submit signature re-encryption in case of the Master DKG key rotation
    /// @param _knotId - BLS public key of the validator
    /// @param _stakehouse - Stakehouse address knot belongs to
    /// @param _ciphertext - Ciphertext formed during the Signing key encryption
    /// @param _aesEncryptorKey - AES key of the encryptor forming the ciphertext
    function reEncryptSigningKey(
        bytes calldata _knotId,
        address _stakehouse,
        bytes calldata _ciphertext,
        bytes calldata _aesEncryptorKey
    ) external;
}
