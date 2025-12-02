// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract UniswapDecoder {

    struct ExactInputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
    }

    error UniswapV3DecoderAndSanitizer__BadPathFormat();

    function exactInput(ExactInputParams calldata params)
        external
        pure
        virtual
        returns (bytes memory addressesFound)
    {
        // Implement
    }   
}