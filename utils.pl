% HELPER FUNCTIONS

is_between(Lower, Upper, X) :-
    Lower =< Upper,
    Lower =< X,
    X =< Upper.
    
%---------------------------------------------------------------------------%

% INPUT VALIDATION

validate_move_board_element_indices(StartRow, StartColumn, EndRow, EndColumn) :-
    is_between(1, 12, StartRow),
    is_between(1, 12, StartColumn),
    is_between(1, 12, EndRow),
    is_between(1, 12, EndColumn), !.
validate_move_board_element_indices(StartRow, _, _, _) :-
    \+ is_between(1, 12, StartRow),
    write('Error: invalid start row index. Start row index must be between 1 and 12.'), nl,
    fail.
validate_move_board_element_indices(_, StartColumn, _, _) :-
    \+ is_between(1, 12, StartColumn),
    write('Error: invalid start column index. Start column index must be between 1 and 12.'), nl,
    fail.
validate_move_board_element_indices(_, _, EndRow, _) :-
    \+ is_between(1, 12, EndRow),
    write('Error: invalid end row index. End row index must be between 1 and 12.'), nl,
    fail.
validate_move_board_element_indices(_, _, _, EndColumn) :-
    \+ is_between(1, 12, EndColumn),
    write('Error: invalid end column index. End column index must be between 1 and 12.'), nl,
    fail.
