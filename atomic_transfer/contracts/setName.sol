pragma solidity ^0.7.6;

contract setName {
    string Name;
    address owner;
    constructor(string memory name)public{
        owner = msg.sender;
        Name = name;

    }

    function changeName(string memory newname) public{
        require(msg.sender == owner,"You are not owner");
        Name = newname;
    }

    function getName() public view returns(string memory){
        return Name;
    }

    function changeOwner(address addy) public {
        owner = addy;
    }
}