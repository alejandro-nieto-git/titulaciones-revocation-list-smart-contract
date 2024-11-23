// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Titulacion Logic Contract
/// @author 
/// @notice This contract manages the revocation status of digital titulaciones (credentials).
/// @dev The contract uses a mapping to track the revocation status of titulaciones by their unique hash (ID).
contract TitulacionDigitalLogic {

    /// @notice Modifier to restrict access to only the admin address.
    modifier onlyAdmin() {
        address admin;
        assembly {
            admin := sload(1)
        }

        require(msg.sender == admin, "Access restricted to the issuer that owns the registry");
        _;
    }

    /// @notice Checks if a given titulacion (identified by its hashed ID) has been revoked.
    /// @param id The hashed ID of the titulacion (as `bytes32`).
    /// @return Returns `true` if the titulacion is revoked, `false` otherwise.
    function isRevoked(bytes32 id) external view returns (bool) {
        bytes32 location = keccak256(abi.encodePacked(id, uint256(2)));
        bool revokationStatus;
        assembly {
            revokationStatus := sload(location)
        }
        return revokationStatus;
    }

    /// @notice Revokes a titulacion, marking it as revoked.
    /// @dev This function checks if the titulacion has already been revoked before updating the mapping.
    /// @param id The hashed ID of the titulacion to be revoked (as `bytes32`).
    /// @custom:throws "Titulacion already revoked" if the titulacion is already marked as revoked.
    function revokeTitulacion(bytes32 id) external onlyAdmin {
        bytes32 location = keccak256(abi.encodePacked(id, uint256(2)));
        bool revokationStatus;
        assembly {
            revokationStatus := sload(location)
        }
        require(!revokationStatus, "Titulacion already revoked");
        assembly {
            sstore(location, true)
        }
    }
}
