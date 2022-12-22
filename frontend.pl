% display_game(+GameState-Player)
display_game(GameState-Player) :-
    initial_board(Board), % fetch the initial board state
    format('~t~1|~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~t~a~t~10+~n', ['a','b','c','d','e','f','g','h','i','j','k','l']),
    format('~t~2|~`-t~9+~`-t~9+~`-t~9+~`-t~9+~`-t~9+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~9+~`-t~5+~n', []),
    maplist(display_row, GameState, [12,11,10,9,8,7,6,5,4,3,2,1]).

display_row(Row, RowNum) :-
    nl,
    format('~d~t~2||', [RowNum]),
    (foreach(BoardPiece, Row), count(ColumnNum, 1, _Max) do
        arg(3, BoardPiece, Type),
        arg(4, BoardPiece, WhitePins),
        arg(5, BoardPiece, BlackPins),
        draw_board_piece(Type, WhitePins, BlackPins)
    ),
    nl,
    format('~t~2|~`-t~9+~`-t~9+~`-t~9+~`-t~9+~`-t~9+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~10+~`-t~9+~`-t~5+~n', []).


% draw_board_piece(+Type, +WhitePins, +BlackPins)
draw_board_piece(Type, WhitePins, BlackPins) :-
    (Type = ' ' -> write('         |'); format(' ~w [~w|~w] |', [Type, WhitePins, BlackPins])).



