// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.8.11;
import "contract/SafeMath.sol";
import "contract/ERC20Interface.sol";

contract ERC20Token is ERC20Interface{
// contract ERC20Token{
    using SafeMath for uint256;

    string private _name;
    string private _symbol;
    uint8 private _decimal;
    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;

    uint256 private _totalSupply;

    // constructor(string memory name1, string memory symbol1, uint8 decimal1){
    //     _name = name1;
    //     _symbol = symbol1;
    //     _decimal = decimal1;
    // }
    constructor(){
        _name = "My First Token";
        _symbol = "MFT";
        _decimal = 18;
        _totalSupply = 10000 * 10 ** _decimal;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() public override view returns (string memory){
        return _name;
    }

    function symbol() public override view returns (string memory){
        return _symbol;
    }

    function decimals() public override view returns (uint8){
        return _decimal;
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner) public override view returns (uint256){
        return _balances[_owner];
    }
    function transfer(address _to, uint256 _value) external override returns (bool success){
        require(_balances[msg.sender] > _value, "low balance");
        require(_to != address(0));
        _balances[msg.sender] = _balances[msg.sender].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success){
        require(_balances[_from] > _value, "low balance");
        require(_to != address(0));
        require(_allowed[_from][msg.sender] > _value);

        _balances[_from] = _balances[_from].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }
    function approve(address _spender, uint256 _value) public override  returns (bool success){
        _allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    function allowance(address _owner, address _spender) public view override returns (uint256 remaining){
        return _allowed[_owner][_spender];
    }
    

    function increaseAllowance(address _spender, uint256 _value) public returns(bool success){
        require(_spender != address(0));
        _allowed[msg.sender][_spender] = (_allowed[msg.sender][_spender].add(_value));
        emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
        return true;
    }

    function decreaseAllowance(address _spender, uint256 _value) public returns(bool success){
        require(_spender != address(0));
        _allowed[msg.sender][_spender] = (_allowed[msg.sender][_spender].sub(_value));
        emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
        return true;
    }

    function _mint(address account, uint256 _value) internal {
        require(address(0)!= account);
        _totalSupply = _totalSupply.add(_value);
        _balances[account] = _balances[account].add(_value);
        emit Transfer(address(0), account, _value);
       
    }

    function _burn(address account, uint256 _value) internal {
        require(address(0)!= account);
        require(_balances[account] >= _value);

        _totalSupply = _totalSupply.sub(_value);
        _balances[account] = _balances[account].sub(_value);
        emit Transfer(account, address(0), _value);
       
    }

    function _burnFrom(address account, uint256 _value) internal {
        require(address(0)!= account);
        require(_allowed[account][msg.sender] >= _value);

        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(_value);
        _burn(account, _value);
       
    }
}