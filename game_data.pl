:- dynamic initial_board/2.

% initial_board(+RowNumber, -Row)
initial_board(12,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(11,  [' ', ' ', 'W', ' ', ' ', ' ', ' ', ' ', ' ', 'B', ' ', ' ']).
initial_board(10,  [' ', 'W', 'W', ' ', 'B', ' ', ' ', 'W', ' ', 'B', 'B', ' ']).
initial_board(9,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(8,  [' ', ' ', 'B', ' ', 'W', ' ', ' ', 'B', ' ', 'W', ' ', ' ']).
initial_board(7,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(6,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(5,  [' ', ' ', 'W', ' ', 'B', ' ', ' ', 'W', ' ', 'B', ' ', ' ']).
initial_board(4,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(3, [' ', 'B', 'B', ' ', 'W', ' ', ' ', 'B', ' ', 'W', 'W', ' ']).
initial_board(2, [' ', ' ', 'B', ' ', ' ', ' ', ' ', ' ', ' ', 'W', ' ', ' ']).
initial_board(1, [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).

reset_board :-
    retractall(initial_board(_, _)),
    asserta(initial_board(12,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '])),
    asserta(initial_board(11,  [' ', ' ', 'W', ' ', ' ', ' ', ' ', ' ', ' ', 'B', ' ', ' '])),
    asserta(initial_board(10,  [' ', 'W', 'W', ' ', 'B', ' ', ' ', 'W', ' ', 'B', 'B', ' '])),
    asserta(initial_board(9,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '])),
    asserta(initial_board(8,  [' ', ' ', 'B', ' ', 'W', ' ', ' ', 'B', ' ', 'W', ' ', ' '])),
    asserta(initial_board(7,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '])),
    asserta(initial_board(6,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '])),
    asserta(initial_board(5,  [' ', ' ', 'W', ' ', 'B', ' ', ' ', 'W', ' ', 'B', ' ', ' '])),
    asserta(initial_board(4,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '])),
    asserta(initial_board(3, [' ', 'B', 'B', ' ', 'W', ' ', ' ', 'B', ' ', 'W', 'W', ' '])),
    asserta(initial_board(2, [' ', ' ', 'B', ' ', ' ', ' ', ' ', ' ', ' ', 'W', ' ', ' '])),
    asserta(initial_board(1, [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '])).

% initial_state(-GameState-Player)
initial_state(GameState-Player) :-
initial_state(12, GameState),
Player = human.

% initial_state(+Size, -GameState)
initial_state(Size, [Row]) :-
Size = 1,
initial_board(1, Row), !.

initial_state(Size, [Row|GameState]) :-
Size > 1,
NSize is Size-1,
initial_state(NSize, GameState),
initial_board(Size, Row).

% display_game(+GameState-Player)
display_game(GameState-Player) :-
    format('~t~1|~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~n', ['a','b','c','d','e','f','g','h','i','j','k','l']),
    format('~t~2|~`-t~9+~`-t~9+~`-t~9+~`-t~9+~`-t~9+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~9+~`-t~5+~n', []),
    (foreach(Row, GameState), count(RowNum, 1, _Max) do 
        nl,
        format('~d~t~1||', [13-RowNum]), 
        format('~t~a~t~10||~t~a~t~10+|~t~a~t~10+|~t~a~t~10+|~t~a~t~10+|~t~a~t~10+|~t~a~t~10+|~t~a~t~10+|~t~a~t~10+|~t~a~t~10+|~t~a~t~10+|~t~a~t~10+|~n', Row), 
        nl,
        format('~t~2|~`-t~9+~`-t~9+~`-t~9+~`-t~9+~`-t~9+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~9+~`-t~5+~n', [])
    ),
    format('Next to move is: ~a.~n', [Player]).

