pragma solidity >=0.5.0;

contract Transfer{
    
    struct transfer{
        address sender;
        address reciever;
        uint amount;
        uint lifetime;
    }
    
    transfer[] public transactions;
    
    event Transfers(address _sender, address _reciever, uint _amount, uint _lifetime);
    
    event Approval(address _owner, address _spender, uint _amount);
    
    mapping(address => uint) public balances;
    
    mapping (address => mapping (address => uint256)) private _allowances;
    
    constructor () public payable {
        address _owner = msg.sender;
        balances[_owner] = _owner.balance;
    }
    
    function _transfer (address _sender, address _reciever, uint _amount, uint _lifetime) public {
        require(_sender != address(0), 'Field \"Sender\" can not be zero.');
        require(_reciever != address(0), 'Field \"Sender\" can not be zero.');
        require(balances[_sender] > _amount, 'You don\'t have enough eth.');
        
        balances[_sender] = _sender.balance - _amount;
        balances[_reciever] = _reciever.balance + _amount;
        transactions.push(transfer(_sender, _reciever, _amount, _lifetime));
        emit Transfers(_sender, _reciever, _amount, _lifetime);
    }
    
    function sendTransaction (address _reciever, uint _amount, uint _lifetime) public {
        _transfer(msg.sender, _reciever, _amount, _lifetime);
    }
    
    function balanceOf () public returns (uint) {
        address owner = msg.sender;
        balances[owner] = owner.balance;
        return balances[owner];
    }
    
    // function _approve (address _owner, address _spender, uint _amount) public returns (bool) {
    //     require(_owner != address(0), 'Field \"Sender\" can not be zero.');
    //     require(_spender != address(0), 'Field \"Sender\" can not be zero.');
        
    //     _allowances[_owner][_spender] = _amount;
    //     emit Approval(_owner, _spender, _amount);
    // }
}