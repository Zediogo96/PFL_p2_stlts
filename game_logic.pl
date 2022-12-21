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



