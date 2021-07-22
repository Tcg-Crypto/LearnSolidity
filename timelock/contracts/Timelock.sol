pragma solidity ^0.8.0;

// use safe math to prevent underflow and overflow
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
 

contract Timelock {
    
    using SafeMath for uint; 
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;
   

    function deposit() external payable {

        //update balance
        balances[msg.sender] +=msg.value;

        //updaes locktime 1 week from now
        lockTime[msg.sender] = block.timestamp + 1 weeks;

    }


    function increaseLockTime(uint _secondsToIncrease) public {

        // the add function below is from safemath and will take care of uint overflow
        // if a call to add causes an error an error will be thrown and the call to the function will fail
         lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToIncrease);

    }

      

    function withdraw() public {

        // check that the sender has ether deposited in this contract in the mapping and the balance is >0
        require(balances[msg.sender] > 0, "insufficient funds");

        // check that the now time is > the time saved in the lock time mapping
        require(block.timestamp > lockTime[msg.sender], "lock time has not expired");
      

        // update the balance
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

       
        // send the ether back to the sender
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send ether");

    }
}