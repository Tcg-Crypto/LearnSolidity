pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";



contract tokenSwap{
    IERC20 public token1;
    address public owner1;
    uint public ammount1;
    IERC20 public token2;
    address public owner2;
    uint public ammount2;

    constructor(
        address _token1,
        address _owner1,
        address _token2,
        address _owner2
    ){
        token1 = IERC20(_token1);
        owner1 = _owner1;
        token2 = IERC20(_token2);
        owner2 = _owner2;
    }   
    function swap(uint _ammount1, uint _ammount2) public {
        require(msg.sender == owner1 || msg.sender == owner2, "Not Owner");
        require(token2.allowance(owner2, address(this)) >= _ammount2,"Token2 too low");
        require(token1.allowance(owner1, address(this)) >= _ammount1,"Token1 too low");
        

        _safetransfer(token1, owner1, owner2, _ammount1);
        _safetransfer(token2, owner2, owner1, _ammount2);
    }

    function _safetransfer(IERC20 token,address from,address to, uint amm)private {
        bool sent = token.transferFrom(from,to,amm);
        require(sent,"Token transfer failed");


    }
}