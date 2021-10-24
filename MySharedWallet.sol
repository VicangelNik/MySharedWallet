//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./Allowance.sol";

contract SharedWallet is Allowance {
    
    // The indexed parameters for logged events will allow you to search for these events using the indexed parameters as filters.
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);

    function getWalletBalance() public view returns (uint)
    {
        return address(this).balance;
    }
    
     function getWalletAddress() public view returns (address)
    {
        return address(this);
    }

    // payable address means that addres can receive ether
    function withdrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Contract doesn't own enough money");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
    
    // View functions ensure that they will not modify the state.
    function renounceOwnership() public override onlyOwner view {
        revert("can't renounceOwnership here"); //not possible with this smart contract
    }

    // If present, the receive ether function is called whenever the call data is empty 
    // (whether or not ether is received). This function is implicitly payable.
    // payable allows a function to receive ether
    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}
