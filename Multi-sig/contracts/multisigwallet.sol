pragma solidity ^0.7.6;

contract multisigwallet {
    event Deposit(address indexed sender, uint ammount, uint balance);
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );
    event ConfirmTX(address indexed owner, uint indexed txIndex);
    event RevokeTX(address indexed owner, uint indexed txIndex);
    event ExecuteTX(address indexed owner, uint indexed txIndex);

    address[] public owners;
    mapping(address => bool) isOwner;
    uint public numConfirmationsRequired;

    struct txstruct{
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
    }

    mapping(uint => mapping(address => bool)) public isConfirmed;

    txstruct[] public transactions;

    modifier onlyOwner(){
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    modifier txExists(uint _txIndex){
        require(_txIndex < transactions.length,"tx does not exist");
        _;
    }

    modifier notExecuted(uint _txIndex){
        require(!transactions[_txIndex].executed,"tx already executed");
        _;
    }

    modifier notConfirmed(uint _txIndex){
        require(!isConfirmed[_txIndex][msg.sender],"tx already confirmed");
        _;
    }

    constructor(address[] memory _owners, uint _numConfirmationsRequired){
        require(_owners.length > 0,"owners required");
        require(
            _numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
            "Invalid number of confirmations"
        );

        for(uint i =0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "invlad owner");
            require(!isOwner[owner], "Owner not unique");

            isOwner[owner] = true;
            owners.push(owner);

        }

        numConfirmationsRequired = _numConfirmationsRequired;


    }

    receive() payable external {
        emit Deposit(msg.sender, msg.value, address(this).balance);
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner{
        uint txIndex = transactions.length;
        transactions.push(txstruct({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            numConfirmations: 0

        }));
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);

    }

    function confirmTX(uint _txIndex)public onlyOwner txExists(_txIndex) notExecuted(_txIndex) notConfirmed(_txIndex){
        txstruct storage transaction = transactions[_txIndex];
        transaction.numConfirmations +=1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTX(msg.sender, _txIndex);

    }

    function executeTX(uint _txIndex)public onlyOwner txExists(_txIndex) notExecuted(_txIndex){
        txstruct storage transaction = transactions[_txIndex];

        require(
            transaction.numConfirmations >= numConfirmationsRequired,
            "cannot execute tx"
        );

        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(transaction.data);
        require(success, "tx failed");

        emit ExecuteTX(msg.sender, _txIndex);


    }

        function getOwners() public view returns (address[] memory) {
        return owners;
    }

}