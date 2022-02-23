//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Faucet {
    address private ERC20TokenAddress; //Address of the ERC20 Token we're tracking
    uint256 private faucetDripAmount; //Amount to be sent
    uint private _ERC20TokenMaximum; //Maximum amount of tokens needs to be considered for this faucet

    constructor(address _ERC20TokenAddress, uint _faucetDripBase, uint _faucetDripDecimal, uint _ERC20TokenMaximum) {
        ERC20TokenAddress = _ERC20TokenAddress; 
        faucetDripAmount = _faucetDripBase * (10**_faucetDripDecimal); //Ether (or Native Token)
    }

    function getBalance() view external returns (uint256) {
        return address(this).balance;
    }

    function getERC20Balance() view external returns (uint256) {
        return ERC20(ERC20TokenAddress).balanceOf(address(this));
    }

    function hasERC20Token(address _user) private view returns(bool) {
        ERC20 instance = ERC20(ERC20TokenAddress);
        if( instance.balanceOf(_user) >= _ERC20TokenMaximum ) {
            return true;
        } else {
            return false;
        }
    }

    function addERC20Token(uint256 _amount) external {
        ERC20 instance = ERC20(ERC20TokenAddress);
        instance.transferFrom(msg.sender, address(this), _amount);
    }

    function faucet(address payable _to) external {
        ERC20 ERC20Token = ERC20(ERC20TokenAddress);
        require(ERC20Token.balanceOf(address(this)) >= faucetDripAmount, "Insufficient Faucet Funds");
        require(!hasERC20Token(_to), "You Already Have Enough ERC20 tokens");
        ERC20Token.transferFrom(address(this), msg.sender, faucetDripAmount);
    }

    fallback() external payable {
    }

    receive() external payable {
    }
}