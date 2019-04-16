pragma solidity 0.4.24;

contract Transfer {
    
    address owner;
    uint public totalPool;
    bool running = true;
    
    struct Account {
        string name;
        uint balance;
        address[] senders;
    }
    
    // PULL OVER PUSHS AND CHECKS EFFECTS INTERACTIONS
    mapping (address => Account) addressToAccount;
    mapping (address => uint) addressToValue;
    
    address[] public accounts;
    event showAmount (uint amount);
    
    constructor() public payable {
        owner = msg.sender;
        accounts = new address[](0);
    }
    
    // ACCESS RESTRICTIONS
    modifier onlyOwner() {
        require(msg.sender == owner, "Access Denied only owner has permission.");
        _;
    }
    
    // GUARD CHECK
    modifier validValue(uint _value) {
        require(msg.value > _value);
        _;
    }
    
    // MAKE SURE ACCOUNT HAS ENOUGH BALANCE
    modifier hasEnoughFunds() {
        require(msg.sender.balance >= msg.value);
        _;
    }
    
    // PULL OVER PUSH
    modifier canWithdrawAmount() {
        require(addressToValue[msg.sender] >= msg.value);
        _;
    }
    
    // GUARD CHECK
    modifier validAddress(address _adr) {
        require(_adr != address(0));
        _;
    }
    
    // EMERGENCY CHECK
    modifier isRunning() {
        require(running == true);
        _;
    }
    
    // TOGGLE CONTRACT RUN STATUS
    function toggleContractStatus() public onlyOwner {
        running = !running;
    }
    
    function getContractStatus() public view returns (bool) {
        return running;
    }
    
    function getAccountsLength() public view returns (uint) {
        return accounts.length;
    }
    
    function getBalance() public view returns (uint) {
        return msg.sender.balance;
    }
    
    // GUARD CHECK AND EMERGENCY STOP
    function addAccount(string _name) public payable validValue(0) isRunning {
        totalPool += msg.value;
        Account storage newAccount;
        newAccount.name = _name;
        newAccount.balance = msg.value;
        accounts.push(msg.sender);
        addressToAccount[msg.sender] = newAccount;
        addressToValue[msg.sender] = msg.value;
        showAmount(msg.value);
    }
    
    function getAccount(uint _index) public view
        returns (
            string,
            uint,
            address[] memory senders
        )
        {
            Account account = addressToAccount[accounts[_index]];
            address[] memory _senders = new address[](account.senders.length);
            for (uint i = 0; i < account.senders.length; i++) {
                _senders[i] = account.senders[i];
            }
            return (
                account.name,
                account.balance,
                _senders
                );
        }
        
    function getValue() public view returns (uint) {
        return addressToValue[msg.sender];
    }
    
    // GUARD CHECK AND CHECK EMERGENCY CONTRACT STATUS
    function deposit() public payable validValue(0) isRunning hasEnoughFunds {
        require(msg.sender != address(0));
        // GET ACCOUNT
        Account storage myAccount = addressToAccount[msg.sender];
        // SEND TRANSACTIONS
        myAccount.balance += msg.value;
        addressToValue[msg.sender] += msg.value;
        totalPool += msg.value;
    }
    
    // CHECKS EFFECTS INTERCATIONS 
    function withdraw(uint _amount) public isRunning canWithdrawAmount {
        // CONVERT TO ETHER
        uint amountToEth = _amount * 1 ether;
        // LOG EVENT
        showAmount(amountToEth);
        // GUARD CHECK
        require(msg.sender != address(0));
        // CHECK ACCOUNT
        Account storage account = addressToAccount[msg.sender];
        // MAKE SURE ACCOUNT HAS ENOUGH BALANCE
        require(account.balance >= amountToEth);
        // SEND TRANSACTIONS
        msg.sender.transfer(amountToEth);
        totalPool -= amountToEth;
        account.balance -= amountToEth;
        addressToValue[msg.sender] -= amountToEth;
    }

    // SECURE ETHER TRANSFER
    function sendMoney(address _receipt, uint amount) public hasEnoughFunds validAddress(_receipt) isRunning {
        // GET ACCOUNTS INVOLVED
        Account storage theAccount = addressToAccount[msg.sender];
        Account storage recieverAccount = addressToAccount[_receipt];
        // CONVERT TO ETH
        uint value = amount * 1 ether;
        // MAKE SURE THE ACCOUNT HAS ENOUGH BALANCE TO SEND
        require(theAccount.balance >= value);
        // SEND TRANSACTIONS
        addressToValue[_receipt] += value;
        addressToValue[msg.sender] -= value;
        recieverAccount.balance += value;
        recieverAccount.senders.push(msg.sender);
        theAccount.balance -= value;
    }
       
}