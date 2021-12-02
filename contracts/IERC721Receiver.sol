// SPDX-License-Identifier: MIT
pragma solidity >=0.5.12;

interface IRC721Receiver {


    function onERC721Received(address operator, address from, uint tokenId, bytes calldata data) external returns (bytes4);



}