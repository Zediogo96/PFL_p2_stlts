% board_element(+RowNumber, +ColumnNumber, ?BoardElement)
board_element(RowNumber, ColumnNumber, BoardElement) :-
    initial_board(RowNumber, Row),
    nth1(ColumnNumber, Row, BoardElement).

change_board(Row, Column, Value) :-
    retract(initial_board(Row, List)),
    replace_at_index(Column, List, Value, NewList),
    assertz(initial_board(Row, NewList)).

replace_at_index(Index, List, Value, NewList) :-
    Index1 is Index - 1,
    length(Before, Index1),
    append(Before, [_|After], List),
    append(Before, [Value|After], NewList).

move_board_element(StartRow, StartColumn, EndRow, EndColumn) :-
    validate_indices(StartRow, StartColumn, EndRow, EndColumn),
    validate_not_diagonal(StartRow, StartColumn, EndRow, EndColumn),
    board_element(StartRow, StartColumn, BoardElement),
    change_board(StartRow, StartColumn, ' '),
    change_board(EndRow, EndColumn, BoardElement).

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
    




