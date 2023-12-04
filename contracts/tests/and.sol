// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "fhevm/lib/TFHE.sol";
import "./utils/utils.sol";

contract And {
    using Utils for *;

    function and(
        uint32 a,
        uint32 b,
        string calldata test,
        bytes32 pubkey
    ) external view returns (bytes memory reencrypted) {
        if (Utils.cmp(test, "and(euint8,euint8)")) {
            return TFHE.reencrypt((TFHE.and(TFHE.asEuint8(a), TFHE.asEuint8(b))), pubkey);
        } else if (Utils.cmp(test, "and(euint8,euint16)")) {
            return TFHE.reencrypt((TFHE.and(TFHE.asEuint8(a), TFHE.asEuint16(b))), pubkey);
        } else if (Utils.cmp(test, "and(euint8,euint32)")) {
            return TFHE.reencrypt(TFHE.and(TFHE.asEuint8(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "and(euint16,euint8)")) {
            return TFHE.reencrypt((TFHE.and(TFHE.asEuint16(a), TFHE.asEuint8(b))), pubkey);
        } else if (Utils.cmp(test, "and(euint16,euint16)")) {
            return TFHE.reencrypt((TFHE.and(TFHE.asEuint16(a), TFHE.asEuint16(b))), pubkey);
        } else if (Utils.cmp(test, "and(euint16,euint32)")) {
            return TFHE.reencrypt(TFHE.and(TFHE.asEuint16(a), TFHE.asEuint32(b)), pubkey);
        } else if (Utils.cmp(test, "and(euint32,euint8)")) {
            return TFHE.reencrypt(TFHE.and(TFHE.asEuint32(a), TFHE.asEuint8(b)), pubkey);
        } else if (Utils.cmp(test, "and(euint32,euint16)")) {
            return TFHE.reencrypt(TFHE.and(TFHE.asEuint32(a), TFHE.asEuint16(b)), pubkey);
        } else if (Utils.cmp(test, "and(euint32,euint32)")) {
            return TFHE.reencrypt(TFHE.and(TFHE.asEuint32(a), TFHE.asEuint32(b)), pubkey);
        } else {
            require(false, string(abi.encodePacked("test '", test, "' not found")));
        }
    }
}
