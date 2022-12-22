:- dynamic initial_board/1.
:- dynamic board_piece/5.

board_piece(RowNumber, ColumnNumber, Type, Whitepins, Blackpins) :-
    member(Type, ['E', 'W', 'B']),
    WhitePins >= 0,
    BlackPins >= 0.

initial_board(
            [[board_piece(12, 1, ' ', 0, 0), 
              board_piece(12, 2, ' ', 0, 0),
              board_piece(12, 3, ' ', 0, 0),
              board_piece(12, 4, ' ', 0, 0),
              board_piece(12, 5, ' ', 0, 0),
              board_piece(12, 6, ' ', 0, 0),
              board_piece(12, 7, ' ', 0, 0),
              board_piece(12, 8, ' ', 0, 0),
              board_piece(12, 9, ' ', 0, 0),
              board_piece(12, 10, ' ', 0, 0),
              board_piece(12, 11, ' ', 0, 0),
              board_piece(12, 12, ' ', 0, 0)],

            [board_piece(11, 1, ' ', 0, 0),
              board_piece(11, 2, 'W', 0, 0),
              board_piece(11, 3, ' ', 0, 0),
              board_piece(11, 4, ' ', 0, 0),
              board_piece(11, 5, ' ', 0, 0),
              board_piece(11, 6, ' ', 0, 0),
              board_piece(11, 7, ' ', 0, 0),
              board_piece(11, 8, ' ', 0, 0),
              board_piece(11, 9, ' ', 0, 0),
              board_piece(11, 10, 'B', 0, 0),
              board_piece(11, 11, ' ', 0, 0),
              board_piece(11, 12, ' ', 0, 0)],
            
            [board_piece(10, 1, ' ', 0, 0),
              board_piece(10, 2, 'W', 0, 0),
              board_piece(10, 3, 'W', 0, 0),
              board_piece(10, 4, ' ', 0, 0),
              board_piece(10, 5, 'B', 0, 0),
              board_piece(10, 6, ' ', 0, 0),
              board_piece(10, 7, ' ', 0, 0),
              board_piece(10, 8, 'W', 0, 0),
              board_piece(10, 9, ' ', 0, 0),
              board_piece(10, 10, 'B', 0, 0),
              board_piece(10, 11, 'B', 0, 0),
              board_piece(10, 12, ' ', 0, 0)],
            
            [board_piece(9, 1, ' ', 0, 0),
              board_piece(9, 2, ' ', 0, 0),
              board_piece(9, 3, ' ', 0, 0),
              board_piece(9, 4, ' ', 0, 0),
              board_piece(9, 5, ' ', 0, 0),
              board_piece(9, 6, ' ', 0, 0),
              board_piece(9, 7, ' ', 0, 0),
              board_piece(9, 8, ' ', 0, 0),
              board_piece(9, 9, ' ', 0, 0),
              board_piece(9, 10, ' ', 0, 0),
              board_piece(9, 11, ' ', 0, 0),
              board_piece(9, 12, ' ', 0, 0)],

              [board_piece(8, 1, ' ', 0, 0),
              board_piece(8, 2, ' ', 0, 0),
              board_piece(8, 3, 'B', 0, 0),
              board_piece(8, 4, ' ', 0, 0),
              board_piece(8, 5, 'W', 0, 0),
              board_piece(8, 6, ' ', 0, 0),
              board_piece(8, 7, ' ', 0, 0),
              board_piece(8, 8, 'B', 0, 0),
              board_piece(8, 9, ' ', 0, 0),
              board_piece(8, 10, 'W', 0, 0),
              board_piece(8, 11, ' ', 0, 0),
              board_piece(8, 12, ' ', 0, 0)],

              [board_piece(7, 1, ' ', 0, 0),
              board_piece(7, 2, ' ', 0, 0),
              board_piece(7, 3, ' ', 0, 0),
              board_piece(7, 4, ' ', 0, 0),
              board_piece(7, 5, ' ', 0, 0),
              board_piece(7, 6, ' ', 0, 0),
              board_piece(7, 7, ' ', 0, 0),
              board_piece(7, 8, ' ', 0, 0),
              board_piece(7, 9, ' ', 0, 0),
              board_piece(7, 10, ' ', 0, 0),
              board_piece(7, 11, ' ', 0, 0),
              board_piece(7, 12, ' ', 0, 0)],

              [board_piece(6, 1, ' ', 0, 0),
              board_piece(6, 2, ' ', 0, 0),
              board_piece(6, 3, ' ', 0, 0),
              board_piece(6, 4, ' ', 0, 0),
              board_piece(6, 5, ' ', 0, 0),
              board_piece(6, 6, ' ', 0, 0),
              board_piece(6, 7, ' ', 0, 0),
              board_piece(6, 8, ' ', 0, 0),
              board_piece(6, 9, ' ', 0, 0),
              board_piece(6, 10, ' ', 0, 0),
              board_piece(6, 11, ' ', 0, 0),
              board_piece(6, 12, ' ', 0, 0)],

              [board_piece(5, 1, ' ', 0, 0),
              board_piece(5, 2, ' ', 0, 0),
              board_piece(5, 3, 'W', 0, 0),
              board_piece(5, 4, ' ', 0, 0),
              board_piece(5, 5, 'B', 0, 0),
              board_piece(5, 6, ' ', 0, 0),
              board_piece(5, 7, ' ', 0, 0),
              board_piece(5, 8, 'W', 0, 0),
              board_piece(5, 9, ' ', 0, 0),
              board_piece(5, 10, 'B', 0, 0),
              board_piece(5, 11, ' ', 0, 0),
              board_piece(5, 12, ' ', 0, 0)],

              [
              board_piece(4, 1, ' ', 0, 0),
              board_piece(4, 2, ' ', 0, 0),
              board_piece(4, 3, ' ', 0, 0),
              board_piece(4, 4, ' ', 0, 0),
              board_piece(4, 5, ' ', 0, 0),
              board_piece(4, 6, ' ', 0, 0),
              board_piece(4, 7, ' ', 0, 0),
              board_piece(4, 8, ' ', 0, 0),
              board_piece(4, 9, ' ', 0, 0),
              board_piece(4, 10, ' ', 0, 0),
              board_piece(4, 11, ' ', 0, 0),
              board_piece(4, 12, ' ', 0, 0)],
              
              [board_piece(3, 1, ' ', 0, 0),
              board_piece(3, 2, 'B', 0, 0),
              board_piece(3, 3, 'B', 0, 0),
              board_piece(3, 4, ' ', 0, 0),
              board_piece(3, 5, 'W', 0, 0),
              board_piece(3, 6, ' ', 0, 0),
              board_piece(3, 7, ' ', 0, 0),
              board_piece(3, 8, 'B', 0, 0),
              board_piece(3, 9, ' ', 0, 0),
              board_piece(3, 10, 'W', 0, 0),
              board_piece(3, 11, 'W', 0, 0),
              board_piece(3, 12, ' ', 0, 0)],

              [board_piece(2, 1, ' ', 0, 0),
              board_piece(2, 2, ' ', 0, 0),
              board_piece(2, 3, 'B', 0, 0),
              board_piece(2, 4, ' ', 0, 0),
              board_piece(2, 5, ' ', 0, 0),
              board_piece(2, 6, ' ', 0, 0),
              board_piece(2, 7, ' ', 0, 0),
              board_piece(2, 8, ' ', 0, 0),
              board_piece(2, 9, ' ', 0, 0),
              board_piece(2, 10, 'W', 0, 0),
              board_piece(2, 11, ' ', 0, 0),
              board_piece(2, 12, ' ', 0, 0)],

              [board_piece(1, 1, ' ', 0, 0),
              board_piece(1, 2, ' ', 0, 0),
              board_piece(1, 3, ' ', 0, 0),
              board_piece(1, 4, ' ', 0, 0),
              board_piece(1, 5, ' ', 0, 0),
              board_piece(1, 6, ' ', 0, 0),
              board_piece(1, 7, ' ', 0, 0),
              board_piece(1, 8, ' ', 0, 0),
              board_piece(1, 9, ' ', 0, 0),
              board_piece(1, 10, ' ', 0, 0),
              board_piece(1, 11, ' ', 0, 0),
              board_piece(1, 12, ' ', 0, 0)]
              ]).
              
reset_board(Board) :-
    retract(initial_board(_)), % remove the current definition of initial_board/1
    assert(initial_board(Board)). % re-assert the initial board state

% initial_state(-GameState-Player)
initial_state(GameState-Player) :-
    initial_board(Board), % fetch the initial board state
    GameState = Board, % assign the initial board state to GameState
    Player = human.

% initial_state(+Size, -GameState)
initial_state(Size, GameState) :-
    initial_board(Board), % fetch the initial board state
    GameState = Board. % assign the initial board state to GameState
               