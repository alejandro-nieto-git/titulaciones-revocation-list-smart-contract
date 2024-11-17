// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Proxy contract for the TitulacionDigital contract
/// @notice This contract delegates all calls to the current implementation contract and allows for upgradeability.
/// @dev This proxy contract uses the delegatecall pattern to separate storage and logic, enabling upgrades without losing state.
contract TitulacionDigitalProxy {
    /// @notice Address of the current implementation contract.
    /// @dev This address is used by the proxy to delegate calls to the current implementation.
    address public implementation;
    /// @notice Address of the current admin of the revokation registry.
    address public admin;
    /// @notice Mapping to store the revocation status of each titulacion.
    /// @dev Maps a hashed titulacion ID (`bytes32`) to a `bool` indicating whether the titulacion is revoked (`true`) or not (`false`).
    mapping(bytes32 => bool) public titulacionesRevocadas;


    /// @notice Event emitted when the implementation contract is upgraded.
    /// @param implementation The address of the new implementation contract.
    event Upgraded(address indexed implementation);

    /// @notice Initializes the proxy with the initial implementation contract.
    /// @param _admin The address of the admin of the revokation registry.
    /// @param _implementation The address of the initial implementation contract.
    constructor(address _admin, address _implementation) {
        require(_implementation != address(0), "Invalid implementation address");
        admin = _admin;
        implementation = _implementation;
    }

    /// @notice Fallback function that delegates all calls to the current implementation contract.
    /// @dev This function is triggered whenever a call to the proxy does not match any function signatures. It forwards the call data to the implementation contract.
    fallback() external payable {
        _delegate(implementation);
    }

    /// @notice Upgrades the implementation contract to a new address.
    /// @dev This function updates the implementation address, allowing the proxy to point to new logic. Access control should be added in production to restrict who can call this function.
    /// @param newImplementation The address of the new implementation contract.
    function upgrade(address newImplementation) external onlyAdmin {
        require(newImplementation != address(0), "Invalid implementation address");
        implementation = newImplementation;
        emit Upgraded(newImplementation);
    }

    /// @notice Internal function to delegate the current call to the specified implementation contract.
    /// @dev This function uses assembly to perform the delegatecall operation, forwarding the data and returning the response.
    /// @param _implementation The address of the implementation contract to which calls will be delegated.
    function _delegate(address _implementation) internal {
        assembly {
            // Copy the input data (msg.data) into memory starting at position 0
            calldatacopy(0, 0, calldatasize())

            // Execute the delegatecall
            // - gas(): passes all available gas to the delegatecall
            // - _implementation: the target address of the implementation contract
            // - 0: the start of the data in memory
            // - calldatasize(): the size of the data in memory
            // - 0: the memory location to store return data
            // - 0: initially no data to return
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data from the delegatecall back into memory
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { 
                revert(0, returndatasize())
            }
            default { 
                return(0, returndatasize())
            }
        }
    }

    /// @notice Modifier to restrict access to only the admin address.
    modifier onlyAdmin() {
        require(msg.sender == admin, "Access restricted to the issuer that owns the registry");
        _;
    }
}
