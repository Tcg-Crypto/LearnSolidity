pragma solidity ^0.7.6;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RockPaperScissors{

    IERC20 public token;
    enum moves{Empty,Rock, Paper, Scissors}
    event newGames(uint indexed totalGames);
    struct Game {
        address Player1;
        address Player2;
        moves move1;
        moves move2;
        uint256 balance;
    }

    Game[] public games;

    constructor(address _token){
        token = IERC20(_token);
    }

    function startGame(address _player1, address _player2, uint _deposit) public{

        require(token.allowance(_player1, address(this)) >= _deposit,"Player 1 allowance too low");
        require(token.allowance(_player2, address(this)) >= _deposit,"Player 2 allowance too low");

        _safetransfer(_player1, _deposit);
        _safetransfer(_player2, _deposit);

        games.push(Game({
            Player1: _player1,
            Player2: _player2,
            balance: _deposit * 2,
            move1: moves.Empty,
            move2: moves.Empty

        }));

        emit newGames(games.length);



    }

    function _safetransfer(address from,uint amm)private {
        bool sent = token.transferFrom(from,address(this),amm);
        require(sent,"Token transfer failed");
    }
    


}