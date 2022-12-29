% get_board_piece(+GameState, +RowNum, +ColumnNum, -BoardPiece)
get_board_piece(RowNum, ColumnNum, BoardPiece) :-
    current_board(Board),
    RowNum1 is 13 - RowNum,
    nth1(RowNum1, Board, Row),
    nth1(ColumnNum, Row, BoardPiece).

get_board_piece_(RowNum, ColumnNum, BoardPiece) :-
    current_board(Board),
    RowNum1 is 13 - RowNum,
    nth1(RowNum1, Board, Row),
    nth1(ColumnNum, Row, BoardPiece).

% replace_board_piece(+RowNum, +ColumnNum, +NewBoardPiece)
replace_board_piece(RowNum, ColumnNum, NewBoardPiece) :-
    current_board(Board),
    % adjust the row number to be in the range 1 to 8
    RowN1 is 13 - RowNum,
    % get the row at the specified index
    nth1(RowN1, Board, Row),
    % replace the element at the specified column in the row
    replace_at_index(Row, ColumnNum, NewBoardPiece, NewRow),
    % replace the row in the board
    replace_at_index(Board, RowN1, NewRow, NewBoard),
    % update the current_board predicate
    retract(current_board(Board)),
    asserta(current_board(NewBoard)).

% replace_at_index(+List, +Index, +Value, -NewList)
replace_at_index(List, Index, Value, NewList) :-
    Index1 is Index - 1,
    length(Before, Index1),
    append(Before, [_|After], List),
    append(Before, [Value|After], NewList).

% move_board_piece(+FromRowNum, +FromColumnNum, +ToRowNum, +ToColumnNum)
move_board_piece(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum) :-
    validate_movement_inputs(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum), % combines validate_indices/4 and validate_not_diagonal/4
    once(move_board_piece_aux(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum)). % use once/1 to prevent backtracking


%validate_move(+FromRowNum, +FromColumnNum, +ToRowNum, +ToColumnNum)
validate_move(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum) :-
    (   FromRowNum == ToRowNum, FromColumnNum \== ToColumnNum % horizontal move
    ->  check_col_range(FromColumnNum, ToColumnNum, FromRowNum),
        check_same_type(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum),
        has_enough_pins(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum)
    ;   FromColumnNum == ToColumnNum, FromRowNum \== ToRowNum % vertical move
    ->  check_row_range(FromRowNum, ToRowNum, FromColumnNum),
        check_same_type(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum),
        has_enough_pins(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum)
        
    ).

% move_board_piece_aux(+FromRowNum, +FromColumnNum, +ToRowNum, +ToColumnNum)
move_board_piece_aux(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum) :-
    get_board_piece(FromRowNum, FromColumnNum, BoardPiece), % get the board piece at the starting position
    % extract board piece information
    BoardPiece = board_piece(_, _, Type, NumWhitePins, NumBlackPins),
    validate_move(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum),
    replace_board_piece(FromRowNum, FromColumnNum, board_piece(FromRowNum, FromColumnNum, ' ', 0, 0)), % remove the board piece at the starting position
    replace_board_piece(ToRowNum, ToColumnNum, board_piece(ToRowNum, ToColumnNum, Type, NumWhitePins, NumBlackPins)). % place the board piece at the ending position



% get_valid_move_destinations(+FromRowNum, +FromColumnNum, -MoveDestinations)
get_valid_move_destinations(FromRowNum, FromColumnNum, MoveDestinations) :-
    % generate all possible ToRowNum and ToColumnNum coordinates
    findall((ToRowNum, ToColumnNum), (member(ToRowNum, [0,1,2,3,4,5,6,7,8,9,10,11]), member(ToColumnNum, [0,1,2,3,4,5,6,7,8,9,10,11]), validate_move(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum)), MoveDestinations).

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

% check_col_range(+StartColumn, +EndColumn, +Row)
check_col_range(StartColumn, EndColumn, Row) :-
    (   StartColumn < EndColumn
    ->  is_column_range_clear_smaller(StartColumn, EndColumn, Row)
    ;   StartColumn > EndColumn,
        is_column_range_clear_greater(StartColumn, EndColumn, Row)
    ).

% is_column_range_clear_smaller(+StartColumn, +EndColumn, +Row)
is_column_range_clear_smaller(StartColumn, EndColumn, Row) :-
    Stop is EndColumn - 1,
    (   StartColumn =:= Stop
    ->  true
    ;   StartColumn1 is StartColumn + 1,
        get_board_piece(Row, StartColumn1, BoardElement),
        (   BoardElement = board_piece(_, _, ' ', _, _)
        ->  is_column_range_clear_smaller(StartColumn1, EndColumn, Row)
        ;   /* write('Error: encountered a non-empty board piece in column range'), nl, */
            fail, !
        )
    ).

% is_column_range_clear_greater(+StartColumn, +EndColumn, +Row)
is_column_range_clear_greater(StartColumn, EndColumn, Row) :-
    Stop is EndColumn + 1,
    (   StartColumn =:= Stop
    ->  true
    ;   StartColumn1 is StartColumn - 1,
        get_board_piece(Row, StartColumn1, BoardElement),
        (   BoardElement = board_piece(_, _, ' ', _, _)
        ->  is_column_range_clear_greater(StartColumn1, EndColumn, Row)
        ;   /* write('Error: encountered a non-empty board piece in column range'), nl, */
            fail, !
        )
    ).

% check_row_range(+StartRow, +EndRow, +Column)
check_row_range(StartRow, EndRow, Column) :-
    SR is 13 - StartRow, ER is 13 - EndRow, % flip the rows so they are in ascending order
    (   SR < ER
    ->  is_row_range_clear_smaller(SR, ER, Column)
    ;   SR > ER,
        is_row_range_clear_greater(SR, ER, Column)
    ).

% is_row_range_clear_smaller(+StartRow, +EndRow, +Column)
is_row_range_clear_smaller(StartRow, EndRow, Column) :-
    Stop is EndRow - 1,
    (   StartRow =:= Stop
    ->  true
    ;   StartRow1 is StartRow + 1,
        get_board_piece(StartRow1, Column, BoardElement), % use get_board_piece/3 instead of board_element/3
        (   BoardElement = board_piece(_, _, ' ', _, _)
        ->  is_row_range_clear_smaller(StartRow1, EndRow, Column)
        ;   /* write('Error: encountered a non-empty board piece in row range'), nl, */
            fail, !
        )
    ).

% is_row_range_clear_greater(+StartRow, +EndRow, +Column)
is_row_range_clear_greater(StartRow, EndRow, Column) :-
    Stop is EndRow + 1,
    (   StartRow =:= Stop
    ->  true
    ;   StartRow1 is StartRow - 1,
        get_board_piece(StartRow1, Column, BoardElement), % use get_board_piece/3 instead of board_element/3
        (   BoardElement = board_piece(_, _, ' ', _, _)
        ->  is_row_range_clear_greater(StartRow1, EndRow, Column)
        ;   /* write('Error: encountered a non-empty board piece in row range'), nl, */
            fail, !
        )
    ).

% check_same_type(+FromRowNum, +FromColumnNum, +ToRowNum, +ToColumnNum)
check_same_type(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum) :-
    get_board_piece(FromRowNum, FromColumnNum, FromBoardPiece),
    get_board_piece(ToRowNum, ToColumnNum, ToBoardPiece),
    % write(FromBoardPiece), write('<---->'), write(ToBoardPiece), nl,
    (   FromBoardPiece = board_piece(_, _, FromType, _, _),
        ToBoardPiece = board_piece(_, _, ToType, _, _),
        FromType = ToType
    ->  /* write('Error: cannot move a piece to a position with a piece of the same type'), nl, */
        fail, !
    ;   true
    ).

% ------------------------ VALIDATE MOVE ------------------------

validate_movement_inputs(StartRow, StartColumn, EndRow, EndColumn) :-
    validate_indices(StartRow, StartColumn, EndRow, EndColumn),
    validate_not_diagonal(StartRow, StartColumn, EndRow, EndColumn).

validate_not_diagonal(StartRow, StartColumn, EndRow, EndColumn) :-
    (StartRow = EndRow, StartColumn = EndColumn ->
     write('Error: start position and end position are the same. Move must be to a different position.'), nl,
     fail ;
     true),
    (abs(StartRow - EndRow) \= abs(StartColumn - EndColumn) ->
     true ;
     /* write('Error: move cannot be diagonal.'), nl, */
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

% has_enough_pins(+FromRowNum, +FromColumnNum, +ToRowNum, +ToColumnNum)
has_enough_pins(FromRowNum, FromColumnNum, ToRowNum, ToColumnNum) :-
    get_board_piece(FromRowNum, FromColumnNum, BoardPiece),
    (   FromRowNum == ToRowNum, FromColumnNum \== ToColumnNum % horizontal move
    ->  BoardPiece = board_piece(_, _, Type, _, BlackPins),
        (   BlackPins >= abs(FromColumnNum - ToColumnNum)
        ->  true
        ;   /* write('Error: not enough black pins to make the move'), nl, */
            false
        )
    ;   FromColumnNum == ToColumnNum, FromRowNum \== ToRowNum % vertical move
    ->  BoardPiece = board_piece(_, _, Type, WhitePins, _),
        (   WhitePins >= abs(FromRowNum - ToRowNum)
        ->  true
        ;   /* write('Error: not enough white pins to make the move'), nl, */
            false
        )
    ).
% ------------------------ END BOUNDARIES CHECK ------------------------

% game_over(+Board, +Player, -Winner)
game_over(Winner) :-
    current_board(Board),
    % count the number of board pieces with type 'B' and type 'W' in the board
    count_board_pieces(Board, 0, 0, BCount, WCount),
    % check if either player has no more board pieces
    (BCount = 0 -> Winner = Player2; WCount = 0 -> Winner = Player1; Winner = 'None').

% -----------------------------------------------------------------------

% closest_black_piece(-RowNum, -ColNum)
closest_black_piece(RowNum, ColNum, WhiteRow, WhiteCol) :-
    findall((X-Y-Dist), (member(X, [1,2,3,4,5,6,7,8,9,10,11,12]), member(Y, [1,2,3,4,5,6,7,8,9,10,11,12]),get_board_piece(X, Y, board_piece(X, Y, 'B', _, _)), distance_to_white_piece(X, Y, Dist)), L),
    sort_list_by_dist(L, SortedList),
    nth1(1, SortedList, (RowNum-ColNum-Dist)),
    arg(1, Dist, Temp),
    arg(1, Temp, WhiteRow), arg(2, Temp, WhiteCol),
    arg(2, Dist, D),
    write('White Piece is: '), write(WhiteRow), write('-'), write(WhiteCol), nl,
    write('Distance is: '), write(D), nl.


% distance_to_white_piece(+RowNum, +ColNum, -Distance)
distance_to_white_piece(RowNum, ColNum,  Distance) :-
    % write('Black Piece at: '), write(RowNum), write('-'), write(ColNum), nl,
    findall(X-Y, (member(X, [1,2,3,4,5,6,7,8,9,10,11,12]), member(Y, [1,2,3,4,5,6,7,8,9,10,11,12]), get_board_piece(X, Y, board_piece(X, Y, 'W', _, _))), WhitePieces),
    maplist(distance(RowNum, ColNum), WhitePieces, Distances),
    % sort the list of distances in ascending order
    sort_list_by_dist(Distances, SortedList),
    % get the first element of the sorted list
    nth1(1, SortedList, Distance).

    
% distance(+RowNum, +ColNum, +WhitePiece, -Distance)
distance(RowNum, ColNum, X-Y, X-Y-Distance) :-
    % write('White Piece at: '), write(X), write('-'), write(Y), write(' '), write('Distance: '),
    Distance is sqrt((RowNum - X)^2 + (ColNum - Y)^2).

% sort_list_by_dist(+List, -SortedList)
sort_list_by_dist(List, SortedList) :-
    sort_list_by_dist(List, [], SortedList).

% sort_list_by_dist(+List, +Acc, -SortedList)
sort_list_by_dist([], Acc, Acc).
sort_list_by_dist([X-Y-Dist|T], Acc, SortedList) :-
    insert_sorted(X-Y-Dist, Acc, Acc1),
    sort_list_by_dist(T, Acc1, SortedList).

% insert_sorted(+Elem, +List, -SortedList)
insert_sorted(X-Y-Dist, [], [X-Y-Dist]).
insert_sorted(X-Y-Dist, [X1-Y1-Dist1|T], [X-Y-Dist,X1-Y1-Dist1|T]) :-
    Dist < Dist1.
insert_sorted(X-Y-Dist, [X1-Y1-Dist1|T], [X1-Y1-Dist1|T1]) :-
    Dist >= Dist1,
    insert_sorted(X-Y-Dist, T, T1).

% find_b(BlackPieces) :-
% findall((X,Y), (member(X, [1,2,3,4,5,6,7,8,9,10,11,12]), member(Y, [1,2,3,4,5,6,7,8,9,10,11,12]), get_board_piece(X, Y, board_piece(X, Y, 'B', _, _))), BlackPieces).