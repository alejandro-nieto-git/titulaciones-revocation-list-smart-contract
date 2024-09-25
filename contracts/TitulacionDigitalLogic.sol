// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Titulacion Logic Contract
/// @author 
/// @notice This contract manages the revocation status of digital titulaciones (credentials).
/// @dev The contract uses a mapping to track the revocation status of titulaciones by their unique hash (ID).
contract TitulacionDigitalLogic {

    /// @notice Mapping to store the revocation status of each titulacion.
    /// @dev Maps a hashed titulacion ID (`bytes32`) to a `bool` indicating whether the titulacion is revoked (`true`) or not (`false`).
    mapping(bytes32 => bool) public titulacionesRevocadas;

    /// @notice Checks if a given titulacion (identified by its hashed ID) has been revoked.
    /// @param id The hashed ID of the titulacion (as `bytes32`).
    /// @return Returns `true` if the titulacion is revoked, `false` otherwise.
    function isRevoked(bytes32 id) external view returns (bool) {
        return titulacionesRevocadas[id];
    }

    /// @notice Revokes a titulacion, marking it as revoked.
    /// @dev This function checks if the titulacion has already been revoked before updating the mapping.
    /// @param id The hashed ID of the titulacion to be revoked (as `bytes32`).
    /// @custom:throws "Titulacion already revoked" if the titulacion is already marked as revoked.
    function revokeTitulacion(bytes32 id) external {
        require(!titulacionesRevocadas[id], "Titulacion already revoked");
        titulacionesRevocadas[id] = true;
    }
}
