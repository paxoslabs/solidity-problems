// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
import { MerkleProofLib } from "@solmate/utils/MerkleProofLib.sol";

contract AaveDecoderAndSanitizer {
    
    function supply(
        address asset,
        uint256,
        address onBehalfOf,
        uint16
    )
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        addressesFound = abi.encodePacked(asset, onBehalfOf);
    }
}

contract Vault {
    function manage(address target, bytes calldata data, uint256 value)
        external
        returns (bytes memory result)
    {
        bool success;
        (success, result) = target.call{value: value}(data);
        if (!success) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }
}

/**
 * @title MerkleMystery
 */
contract MerkleMystery {

    error CustomError();

    mapping(address => bytes32) public manageRoot;

    Vault public immutable vault;

    function manageVaultWithMerkleVerification(
        bytes32[][] calldata manageProofs,
        address[] calldata decodersAndSanitizers,
        address[] calldata targets,
        bytes[] calldata targetData,
        uint256[] calldata values
    ) external {
        bytes32 strategistManageRoot = manageRoot[msg.sender];
        
        uint256 targetsLength = targets.length;
        for (uint256 i; i < targetsLength; ++i) {
            _verifyCallData(
                strategistManageRoot, manageProofs[i], decodersAndSanitizers[i], targets[i], values[i], targetData[i]
            );
            vault.manage(targets[i], targetData[i], values[i]);
        }
    }

    function _verifyCallData(
        bytes32 currentManageRoot,
        bytes32[] calldata manageProof,
        address decoderAndSanitizer,
        address target,
        uint256 value,
        bytes calldata targetData
    ) internal view {
        // Use address decoder to get addresses in call data.
        (bool success, bytes memory returndata) = decoderAndSanitizer.staticcall(targetData);
        if (!success) {
            assembly {
                revert(add(returndata, 32), mload(returndata))
            }
        }
        bytes memory packedArgumentAddresses = abi.decode(returndata, (bytes));

        if (!_verifyManageProof(
                currentManageRoot,
                manageProof,
                target,
                decoderAndSanitizer,
                value,
                bytes4(targetData),
                packedArgumentAddresses
            )) {
            revert CustomError();
        }
    }

    function _verifyManageProof(
        bytes32 root,
        bytes32[] calldata proof,
        address target,
        address decoderAndSanitizer,
        uint256 value,
        bytes4 selector,
        bytes memory packedArgumentAddresses
    ) internal pure returns (bool) {
        bool valueNonZero = value > 0;

        bytes32 leaf =
            keccak256(abi.encodePacked(decoderAndSanitizer, target, valueNonZero, selector, packedArgumentAddresses));

        return MerkleProofLib.verify(proof, root, leaf);
    }
}
