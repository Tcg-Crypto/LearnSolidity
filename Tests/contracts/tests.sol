pragma solidity 0.6.6;

    
import "@openzeppelin/contracts/utils/Counters.sol";


contract tests {

         using Counters for Counters.Counter;

        Counters.Counter private _tokenCounter;
        uint256 public tokenCounterOut;
        event whatCount(uint256 count);


        constructor() public{
            tokenCounterOut = _tokenCounter.current();
        }

        function addNum() public payable {
            require(msg.value >= 1e16, "Not sending enough eth");
            _tokenCounter.increment();
            tokenCounterOut = _tokenCounter.current();
            emit whatCount(tokenCounterOut);
        }

        function getCounter() public view returns (uint256) {
        return tokenCounterOut;
    }




}