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

% ------------------------ BOUNDARIES CHECK ------------------------

check_col_range(StartColumn, EndColumn, Row) :-
    StartColumn < EndColumn,
    is_column_range_clear_smaller(StartColumn, EndColumn, Row);
    StartColumn > EndColumn,
    is_column_range_clear_greater(StartColumn, EndColumn, Row).

is_column_range_clear_smaller(StartColumn, EndColumn, Row) :-
    Stop is EndColumn - 1,
    StartColumn =:= Stop;
    StartColumn1 is StartColumn + 1,
    board_element(Row, StartColumn1, BoardElement),
    write('-'), write(BoardElement), nl,
    BoardElement = ' ',
    is_column_range_clear_smaller(StartColumn1, EndColumn, Row).

is_column_range_clear_greater(StartColumn, EndColumn, Row) :-
    Stop is EndColumn + 1,
    StartColumn =:= Stop;
    StartColumn1 is StartColumn - 1,
    board_element(Row, StartColumn1, BoardElement),
    write('-'), write(BoardElement), nl,
    BoardElement = ' ',
    is_column_range_clear_greater(StartColumn1, EndColumn, Row).

check_row_range(StartRow, EndRow, Column) :-
    StartRow < EndRow,
    is_row_range_clear_smaller(StartRow, EndRow, Column);
    StartRow > EndRow,
    is_row_range_clear_greater(StartRow, EndRow, Column).

is_row_range_clear_smaller(StartRow, EndRow, Column) :-
    Stop is EndRow - 1,
    StartRow =:= Stop;
    StartRow1 is StartRow + 1,
    board_element(StartRow1, Column, BoardElement),
    BoardElement = ' ',
    is_row_range_clear_smaller(StartRow1, EndRow, Column).

is_row_range_clear_greater(StartRow, EndRow, Column) :-
    Stop is EndRow + 1,
    StartRow =:= Stop;
    StartRow1 is StartRow - 1,
    board_element(StartRow1, Column, BoardElement),
    BoardElement = ' ',
    is_row_range_clear_greater(StartRow1, EndRow, Column).

% ------------------------ END BOUNDARIES CHECK ------------------------
    




