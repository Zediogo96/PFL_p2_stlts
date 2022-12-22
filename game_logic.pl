% get_board_piece(+GameState, +RowNum, +ColumnNum, -BoardPiece)
get_board_piece(RowNum, ColumnNum, BoardPiece) :-
    initial_board(Board),
    RowNum1 is 13 - RowNum,
    nth1(RowNum1, Board, Row),
    nth1(ColumnNum, Row, BoardPiece).

% replace_board_piece(+RowNum, +ColumnNum, +NewBoardPiece)
replace_board_piece(RowNum, ColumnNum, NewBoardPiece) :-
    initial_board(GameState),
    RowN1 is 13 - RowNum,
    nth1(RowN1, GameState, Row),
    replace_at_index(Row, ColumnNum, NewBoardPiece, NewRow),
    replace_at_index(GameState, RowN1, NewRow, NewGameState),
    retract(initial_board(GameState)),
    assertz(initial_board(NewGameState)).

% replace_at_index(+List, +Index, +Value, -NewList)
replace_at_index(List, Index, Value, NewList) :-
    Index1 is Index - 1,
    length(Before, Index1),
    append(Before, [_|After], List),
    append(Before, [Value|After], NewList).

% move_board_piece(+FromRowNum, +FromColumnNum, +ToRowNum, +ToColumnNum)
move_board_piece(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum) :-
    initial_board(GameState),
    get_board_piece(FromRowNum, FromColumnNum, BoardPiece),
    replace_board_piece(FromRowNum, FromColumnNum, board_piece(FromRowNum, FromColumnNum, ' ', 0, 0)),
    replace_board_piece(ToRowNum, ToColumnNum, BoardPiece).


% ------------------------ UPDATE PINS -----------------------------

increment_white_pin(RowNum, ColumnNum) :-
    get_board_piece(RowNum, ColumnNum, BoardPiece),
    BoardPiece = board_piece(_, _, Type, NumWhitePins, NumBlackPins),
    Type \= ' ', % VALIDATE IF POSITION IS NOT EMPTY
    NewNumWhitePins is NumWhitePins + 1,
    replace_board_piece(RowNum, ColumnNum, board_piece(RowNum, ColumnNum, Type, NewNumWhitePins, NumBlackPins)).

increment_black_pin(RowNum, ColumnNum) :-
    get_board_piece(RowNum, ColumnNum, BoardPiece),
    BoardPiece = board_piece(_, _, Type, NumWhitePins, NumBlackPins),
    Type \= ' ', % VALIDATE IF POSITION IS NOT EMPTY
    NewNumBlackPins is NumBlackPins + 1,
    replace_board_piece(RowNum, ColumnNum, board_piece(RowNum, ColumnNum, Type, NumWhitePins, NewNumBlackPins)).

% ------------------------ BOUNDARIES CHECK ------------------------

check_col_range(StartColumn, EndColumn, Row) :-
    R is 13 - Row,
    StartColumn < EndColumn,
    is_column_range_clear_smaller(StartColumn, EndColumn, R);
    StartColumn > EndColumn,
    is_column_range_clear_greater(StartColumn, EndColumn, R).

is_column_range_clear_smaller(StartColumn, EndColumn, Row) :-
    Stop is EndColumn - 1,
    StartColumn =:= Stop;
    StartColumn1 is StartColumn + 1,
    get_board_piece(Row, StartColumn1, BoardElement),
    BoardElement = board_piece(_, _, ' ', _, _),
    is_column_range_clear_smaller(StartColumn1, EndColumn, Row).

is_column_range_clear_greater(StartColumn, EndColumn, Row) :-
    Stop is EndColumn + 1,
    StartColumn =:= Stop;
    StartColumn1 is StartColumn - 1,
    get_board_piece(Row, StartColumn1, BoardElement),
    BoardElement = board_piece(_, _, ' ', _, _),
    is_column_range_clear_greater(StartColumn1, EndColumn, Row).

check_row_range(StartRow, EndRow, Column) :-
    SR is 13 - StartRow, ER is 13 - EndRow,
    SR < ER,
    is_row_range_clear_smaller(SR, ER, Column);
    SR > ER,
    is_row_range_clear_greater(SR, ER, Column).

is_row_range_clear_smaller(StartRow, EndRow, Column) :-
    Stop is EndRow - 1,
    StartRow =:= Stop;
    StartRow1 is StartRow + 1,
    board_element(StartRow1, Column, BoardElement),
    BoardElement = board_piece(_, _, ' ', _, _),
    is_row_range_clear_smaller(StartRow1, EndRow, Column).

is_row_range_clear_greater(StartRow, EndRow, Column) :-
    Stop is EndRow + 1,
    StartRow =:= Stop;
    StartRow1 is StartRow - 1,
    board_element(StartRow1, Column, BoardElement),
    BoardElement = board_piece(_, _, ' ', _, _),
    is_row_range_clear_greater(StartRow1, EndRow, Column).

% ------------------------ VALIDATE MOVE ------------------------

validate_not_diagonal(StartRow, StartColumn, EndRow, EndColumn) :-
    (StartRow = EndRow, StartColumn = EndColumn ->
     write('Error: start position and end position are the same. Move must be to a different position.'), nl,
     fail ;
     true),
    (abs(StartRow - EndRow) \= abs(StartColumn - EndColumn) ->
     true ;
     write('Error: move cannot be diagonal.'), nl,
     fail).

validate_indices(StartRow, StartColumn, EndRow, EndColumn) :-
    is_between(1, 12, StartRow),
    is_between(1, 12, StartColumn),
    is_between(1, 12, EndRow),
    is_between(1, 12, EndColumn), !.
validate_indices(StartRow, _, _, _) :-
    \+ is_between(1, 12, StartRow),
    write('Error: invalid start row index. Start row index must be between 1 and 12.'), nl,
    fail.
validate_indices(_, StartColumn, _, _) :-
    \+ is_between(1, 12, StartColumn),
    write('Error: invalid start column index. Start column index must be between 1 and 12.'), nl,
    fail.
validate_indices(_, _, EndRow, _) :-
    \+ is_between(1, 12, EndRow),
    write('Error: invalid end row index. End row index must be between 1 and 12.'), nl,
    fail.
validate_indices(_, _, _, EndColumn) :-
    \+ is_between(1, 12, EndColumn),
    write('Error: invalid end column index. End column index must be between 1 and 12.'), nl,
    fail.

% ------------------------ END BOUNDARIES CHECK ------------------------

% move

