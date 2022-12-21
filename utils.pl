% HELPER FUNCTIONS

is_between(Lower, Upper, X) :-
    Lower =< Upper,
    Lower =< X,
    X =< Upper.
    
%---------------------------------------------------------------------------%

% INPUT VALIDATION

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


%---------------------------------------------------------------------------%

% GAME LOGIC VALIDATION

validate_not_diagonal(StartRow, StartColumn, EndRow, EndColumn) :-
    (StartRow = EndRow, StartColumn = EndColumn ->
     write('Error: start position and end position are the same. Move must be to a different position.'), nl,
     fail ;
     true),
    (abs(StartRow - EndRow) \= abs(StartColumn - EndColumn) ->
     true ;
     write('Error: move cannot be diagonal.'), nl,
     fail).


%---------------------------------------------------------------------------%


atomic_list_concat(Atom,Separator,Res) :- atom_chars(Atom,CAtom),
                                          atomic_list_concat_(CAtom,Separator,List),
                                          maplist(atom_chars,Res,List).

atomic_list_concat_([],_,[[]]) :- ! .

atomic_list_concat_([A|As],Sep,[[]|Args]) :- A = Sep,
                                             atomic_list_concat_(As,Sep,Args).

atomic_list_concat_([A|As],Sep,[[A|Arg]|Args]) :- A\=Sep,
                                                  atomic_list_concat_(As,Sep,[Arg|Args]).




