# Stlts

## Project description 

Stlts is a strategy game developed using Prolog for FEUP's PFL (Logic and Functional Programming) course.

### Group members

- Afonso Martins, [up202005900](mailto:up202005900@edu.fe.up.pt) | Contribution: 50%.
- José Diogo Pinto [up202003529](mailto:up202003529@edu.fe.up.pt) | Contribution: 50%.

## Installation And Execution

### Requisites

- SICStus Prolog 4.7.1

### Running the game

1. Change directory to the  `/src` folder
2. Open SICStus Prolog
3. Run `consult('main.pl').` to start the game application
4. To start the game, run `play.`

## Game Rules

Stlts is a strategic board game, played on a 12x12 checkerboard with cork-centered pieces into which pins are placed. The object of the game is to take all the opponent's pieces.

Players take turns. White begins.

On each turn a player may either

- insert a pin of either color in one of their pieces
- move one of their pieces

A piece may move to any square that can be reached by a sequence of one-square horizontal and vertical moves where the maximum number of vertical moves is the number of white pins in the piece and the maximum number of horizontal moves is the number of black pins (a piece with no pins cannot move). A piece may not move through a square occupied by another piece of either color. To take an opponent's piece a player moves to that square and it is removed.

More information [here](https://boardgamegeek.com/boardgame/16237/stlts).

## How to play

In this digital version of the game, there are 3 game modes:

- Player x Player - Players take turns to try and beat each other.
- Player x Bot - The player faces a bot that can play the game by choosing random moves (difficulty level 1) or the best move at the moment, using a greedy algorithm (difficulty level 2).
- Bot x Bot - The bot plays against itself, with the same difficulty levels as the previous mode.

## Game logic

### Internal representation of the state of the game






### Game state view



### Moves Execution




### List of Valid Moves

During the development of the game, it proved necessary to have some kind of way of letting the player know the possible moves based on the chosen piece. This was also useful for analyzing the possible plays for the bot. To implement this, we chose to ask the player for the coordinates on the board of the desired piece, and then present the options for adding pins, or moving the piece. If there are moves available for that piece, the player can choose one from the list, if not, the only option is to place a new pin. 

To do this, we use the following predicates:

| Predicate   | Description |
| ----------- | ----------- |
|             |             |
|             |             |


### End of Game
### Board Evaluation
### Computer move



Our `GameState` predicate is composed of `GameBoard` and `PlayerTurn` (`GameState` = `[GameState|PlayerTurn]`), where:

- `GameBoard` is represented by a 2d list, in which each sublist is a line in the board.
In the `initial_state(+Size, -GameState)` predicate, an initial gameboard is generated with first and last rows being the player pieces (white and black respectively) and the rest being the empty cells that the pieces can move.
- `PlayerTurn` can either be a value of `black` or `white` indicating the current player turn.

The view of the game is output by the predicate `display_game(+GameState)`, where it loops through the `GameBoard` cell by cell and outputs the respective element, and then outputs the player that has to make a move in the current turn.


![main menu](./img/menu.png)

#### **Player x Player**

After choosing the size of the square board the game will begin being the player one the one to control the white marblers and player 2 the one to control the black marbles.

![menu_board](./img/select_board.png)

#### **Player x Computer**

After choosing the square board size like in the first option now we need to choose which player we wan't to be.

If the player choose to be black, then the computer will make it's first move and the game will begin soon after that.

![menu computer](./img/choose_player_x_computer.png)

After every movement, being that from the player or the computer, we have presented in the screen the current movement with a marble initial position and last position.

![menu computer](./img/8x8_board.png)

### Movement
 Each turn a player is asked to input their movement, the input should be similar to the standard method for recording and describing the *moves in a game of chess for a pawn* (e.g. to move a piece on position B1 to B3, input `b1b3.`, everything together without spaces)

 The input that the player entered, is validated and parsed, when an invalid move is taken, a error message is returned and the player is asked to input again.

The validation proccess is also combined with the predicate `valid_moves_by_piece(+PiecePosition, +GameBoard, -ListOfMoves)` by checking if the move that the player has entered is one of a valid moves on the `ListOfMoves`.

After parsing and validating the input, a move is executed using the predicate `move(+GameState, +Move, -NewGameState)`, which replaces the piece on the old position on the board by `empty`, and the new position is replaced with current player's piece.


### List of valid moves

The combination of row column determines what is a position, and the direction of a move can only be vertical and horizontal movements (no diagonals).

We endup choosing a very straight foward and simple way to play, once it's your turn all the player need to type in is the current position of a marble and the desired new position.

The predicates used for this validations is  `valid_moves_by_piece(+PiecePosition, +GameBoard, -ListOfMoves)`

The predicate `valid_moves(+GameState, -ListOfMoves).`, uses the current game state (game board + current player turn) to find out all the possible moves that the current player can make, this is done by checking all the horizontal and vertical valid moves that each piece of their color can take and stored into the `ListOfMoves`.


### Computer

The game can be also played in the player x computer mode, where the player is first asked in the main menu the color that one wants to play, after that it will be headed into a `computer_player_gameloop`, where the computer and the player takes turns on their play.

1. On computer's turn, it chooses a move using the `choose_move(+GameState, +Level, -Move)` , which uses the predicate mentioned previously `valid_moves(+GameState, -ListOfMoves)` to give a list of valid moves that the current pieces can make.
2. Then, the predicate `random` is used to give a random index in the list of valid moves, and this move is selected, and played by the computer.


### Game Over

For validation of game over, we used a combination of verification in the Board from within the Game State and Setting a Flag from within the game loop predicates (this includes `computer_player_gameloop` and `player_player_gameloop` predicates).

1. For each game loop, we first check if the current game state (given by `GameState`) has sastified a condition to end the game, using the predicate `game_over(+GameState, -Winner)`.
2. This predicate checks whether the current player has its pieces amount inferior to 2, and if so, we can conclude that the previous player has played a move that gave a 'checkmate' to this current player, and therefore conclude with a winner, and the game loop is stopped.
3. If there is not a game over condition, then `Winner` will be given the value `none` and the game will be continued.


### Example of Game winning

The capture can occour if horizontally or vertically: 
-  you position your marble in between two enemy marbles
![menu computer](./img/black_before.png)
![menu computer](./img/black_win.png)
- you position two of your marbles around an enemy marble.
![menu computer](./img/white_before.png)
![menu computer](./img/white_win.png)


### Conclusions

Developing a game in Prolog was a highly educational and enriching experience. It allowed us to improve our skills and expand our knowledge in the field of programming. The use of the Prolog/logical programming paradigm offered a unique and interesting approach to game development, introducing us to new ways of thinking about problem-solving and logic. Overall, the project was a valuable and enjoyable learning experience that we would recommend to others interested in exploring different programming paradigms.

### Bibliography
***
- [igGameCenter](https://www.iggamecenter.com/en/rules/stlts)
- [Board Game Geek](https://boardgamegeek.com/boardgame/16237/stlts)
- [SicTus Prolog 4](https://sicstus.sics.se/)
