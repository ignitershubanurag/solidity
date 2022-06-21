// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.11;
import "SafeMath.sol";
import "ERC20Interface.sol";

contract ERC20Token is ERC20Interface{
    using SafeMath for uint256;

    string private name;

    function name() public view returns (string){
        return name;
    }
}