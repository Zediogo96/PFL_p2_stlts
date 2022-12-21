% include nth1
:- use_module(library(lists)).

% initial_board(+RowNumber, -Row)
initial_board(12,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(11,  [' ', ' ', 'WHITE', ' ', ' ', ' ', ' ', ' ', ' ', 'BLACK', ' ', ' ']).
initial_board(10,  [' ', 'WHITE', 'WHITE', ' ', 'BLACK', ' ', ' ', 'WHITE', ' ', 'BLACK', 'BLACK', ' ']).
initial_board(9,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(8,  [' ', ' ', 'BLACK', ' ', 'WHITE', ' ', ' ', 'BLACKS', ' ', 'WHITE', ' ', ' ']).
initial_board(7,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(6,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(5,  [' ', ' ', 'WHITE', ' ', 'BLACK', ' ', ' ', 'WHITE', ' ', 'BLACK', ' ', ' ']).
initial_board(4,  [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).
initial_board(3, [' ', 'BLACK', 'BLACK', ' ', 'WHITE', ' ', ' ', 'BLACK', ' ', 'WHITE', 'WHITE', ' ']).
initial_board(2, [' ', ' ', 'BLACK', ' ', ' ', ' ', ' ', ' ', ' ', 'WHITE', ' ', ' ']).
initial_board(1, [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']).

    % board_element(+RowNumber, +ColumnNumber, ?BoardElement)
% board_element(+RowNumber, +ColumnNumber, ?BoardElement)
board_element(RowNumber, ColumnNumber, BoardElement) :-
    initial_board(RowNumber, Row),
    get_element(ColumnNumber, Row, BoardElement).

% get_element(+Index, +List, -Element)
get_element(1, [Element|_], Element).
get_element(Index, [_|Tail], Element) :-
    Index > 1,
    NextIndex is Index - 1,
    get_element(NextIndex, Tail, Element).

% menu_option(+OptionNumber, -Option)
menu_option(1, play).
menu_option(2, instructions).
menu_option(3, quit).

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


play :-
    initial_state(GameState-Player),
    display_game(GameState-Player).

instructions :-
    write(' _____________________________________________________________'), nl,
    write('|                     Stlts - Board Game                      |'), nl,
    write('|_____________________________________________________________|'), nl,
    write('|                        Instructions:                        |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|_____________________________________________________________|'), nl,

    call(menu).

quit :-
    nl.

menu :-
    repeat,
    nl,
    write('Please select a number:'), nl,
    write_menu_list,
    read(OptionNumber),
    (   menu_option(OptionNumber, OptionName) ->  write('You selected: '), write(OptionName), nl, !;
        write('Not a valid choice, try again...'), nl, fail
    ),
    nl,
    call(OptionName).

write_menu_list :-
    menu_option(N, Name),
    write(N), write('. '), write(Name), nl,
    fail.
write_menu_list.