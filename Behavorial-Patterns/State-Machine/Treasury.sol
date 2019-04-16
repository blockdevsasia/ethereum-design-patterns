pragma solidity 0.4.24;

contract Treasury {
    
    enum State {
        Audit,
        Collect
    }
    
    address public owner;
    uint public totalPool;
    State public currentState = State.Collect;
    
    struct Collector {
        string name;
        uint collection;
        mapping(address => uint) collectibles;
    }
    
    struct Auditor {
        string name;
        uint totalAudit;
        mapping(address => uint) audits;
    }
    
    mapping (address => bool) addressIsAuditor;
    mapping (address => bool) addressIsCollector;
    mapping (address => Auditor) addressToAuditor;
    mapping (address => Collector) addressToCollector;
    
    address[] auditorAddresses;
    address[] collectorAddresses;
    
    constructor() public payable {
        owner = msg.sender;
        auditorAddresses = new address[](0);
        collectorAddresses = new address[](0);
    }
    
    modifier validAmount(uint value) {
        require(value > 0);
        _;
    }
    
    modifier validAddress() {
        require(msg.sender != address(0));
        _;
    }
    
    modifier senderIsCollector() {
        require(addressIsCollector[msg.sender] == true);
        _;
    }
    
    modifier senderIsAuditor() {
        require(addressIsAuditor[msg.sender] == true);
        _;
    }
    
    modifier validInput(string _name) {
        bytes32 converted = keccak256(_name);
        require(converted != keccak256(""));
        _;
    }
    
    modifier validInputAddress(address _adr) {
        require(_adr != address(0));
        _;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function createCollector(string _name) public validAddress validInput(_name) {
        require(addressIsAuditor[msg.sender] == false);
        Collector memory newCollector = Collector({
            name: _name,
            collection: 0
        });
        addressToCollector[msg.sender] = newCollector;
        collectorAddresses.push(msg.sender);
        addressIsCollector[msg.sender] = true;
    }
    
    function getCollector(uint _index) public view returns (string, uint) {
        Collector memory collector = addressToCollector[collectorAddresses[_index]];
        return (
                collector.name,
                collector.collection
            );
    }
    
    function collectMoney(address _collectee, uint _amount) public senderIsCollector validInputAddress(_collectee) validAmount(_amount) {
        if (currentState != State.Collect) {
            currentState = State.Collect;
        }
        uint convertedAmount = _amount * 1 ether;
        require(currentState == State.Collect);
        Collector storage collector = addressToCollector[msg.sender];
        collector.collectibles[_collectee] = convertedAmount;
        collector.collection += convertedAmount;
    }
    
    function createAuditor(string _name) public validAddress validInput(_name) {
        require(addressIsCollector[msg.sender] == false);
        Auditor memory newAuditor = Auditor({
            name: _name,
            totalAudit: 0
        });
        addressToAuditor[msg.sender] = newAuditor;
        addressIsAuditor[msg.sender] = true;
        auditorAddresses.push(msg.sender);
    }
    
    function getAuditor(uint _index) public view returns (string, uint) {
        Auditor memory auditor = addressToAuditor[auditorAddresses[_index]];
        return (
                auditor.name,
                auditor.totalAudit
            );
    }
    
    function audit(address _collectorAddress, uint _amount ) public
        senderIsAuditor validInputAddress(_collectorAddress) validAmount(_amount) {
        if (currentState != State.Audit) {
            currentState = State.Audit;
        }
        require(currentState == State.Audit);
        Collector storage collector = addressToCollector[_collectorAddress];
        require(collector.collection >= _amount);
        uint convertedAmount = _amount * 1 ether;
        Auditor storage auditor = addressToAuditor[msg.sender];
        collector.collection -= convertedAmount;
        auditor.totalAudit += convertedAmount;
        auditor.audits[_collectorAddress] = convertedAmount;
    }
    
    function sendToTreasury() public payable senderIsAuditor validAmount(msg.value) {
        Auditor storage auditor = addressToAuditor[msg.sender];
        require(auditor.totalAudit >= msg.value);
        auditor.totalAudit -= msg.value;
        totalPool += msg.value;
    }
    
    function withdraw(uint _amount) public payable onlyOwner validAmount(_amount) {
        uint convertedAmount = _amount * 1 ether;
        require(totalPool >= convertedAmount);
        owner.transfer(convertedAmount);
        totalPool -= convertedAmount;
    }
    
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function terminateContract() public onlyOwner {
        selfdestruct(owner);
    }
    
}