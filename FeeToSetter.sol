/**
 *Submitted for verification at Etherscan.io on 2020-09-16
*/

pragma solidity ^0.5.16;

// this contract serves as feeToSetter, allowing owner to manage fees in the context of a specific feeTo implementation
contract FeeToSetter {
    // immutables
    address public factory;
    uint public vestingEnd;
    address public feeTo;

    address public owner;

    // 4 Constructor Arguments found :
    // Arg [0] : 0000000000000000000000005c69bee701ef814a2b6a3edd4b1652cb9cc5aa6f
    // Arg [1] : 00000000000000000000000000000000000000000000000000000000603c2e80
    // Arg [2] : 0000000000000000000000001a9c8182c09f50c8318d769245bea52c32be35bc
    // Arg [3] : 000000000000000000000000daf819c2437a82f9e01f6586207ebf961a7f0970
    constructor(address factory_, uint vestingEnd_, address owner_, address feeTo_) public {
        require(vestingEnd_ > block.timestamp, 'FeeToSetter::constructor: vesting must end after deployment');
        factory = factory_;
        vestingEnd = vestingEnd_;
        owner = owner_;
        feeTo = feeTo_;
    }

    // allows owner to change itself at any time
    function setOwner(address owner_) public {
        require(msg.sender == owner, 'FeeToSetter::setOwner: not allowed');
        owner = owner_;
    }

    // allows owner to change feeToSetter after vesting
    function setFeeToSetter(address feeToSetter_) public {
        require(block.timestamp >= vestingEnd, 'FeeToSetter::setFeeToSetter: not time yet');
        require(msg.sender == owner, 'FeeToSetter::setFeeToSetter: not allowed');
        IUniswapV2Factory(factory).setFeeToSetter(feeToSetter_);
    }

    // allows owner to turn fees on/off after vesting
    function toggleFees(bool on) public {
        require(block.timestamp >= vestingEnd, 'FeeToSetter::toggleFees: not time yet');
        require(msg.sender == owner, 'FeeToSetter::toggleFees: not allowed');
        IUniswapV2Factory(factory).setFeeTo(on ? feeTo : address(0));
    }
}

interface IUniswapV2Factory {
    function setFeeToSetter(address) external;
    function setFeeTo(address) external;
}