% HELPER PREDICATES

% is_between(+Lower, +Upper, +X), helper predicate to check boundaries
is_between(Lower, Upper, X) :-
    Lower =< Upper,
    Lower =< X,
    X =< Upper.

% char_to_int(+Char, -Int), converts an alphabetic character to an Integer
% e.g. -> char_to_int('a', 1), char_to_int('b', 2), char_to_int('c', 3), etc.
char_to_int(Char, Int) :-
    char_code(Char, Code),
    Int is Code - 96.

% int_to_char(+Int, -Char), converts an Integer to an alphabetic character
% e.g. -> int_to_char(1, 'a'), int_to_char(2, 'b'), int_to_char(3, 'c'), etc.
int_to_char(Int, Char) :-
Code is Int + 96,
char_code(Char, Code).

%---------------------------------------------------------------------------%


atomic_list_concat(Atom,Separator,Res) :- atom_chars(Atom,CAtom),
                                          atomic_list_concat_(CAtom,Separator,List),
                                          maplist(atom_chars,Res,List).

atomic_list_concat_([],_,[[]]) :- ! .

atomic_list_concat_([A|As],Sep,[[]|Args]) :- A = Sep,
                                             atomic_list_concat_(As,Sep,Args).

atomic_list_concat_([A|As],Sep,[[A|Arg]|Args]) :- A\=Sep,
                                                  atomic_list_concat_(As,Sep,[Arg|Args]).

% ---------------------------------------------------------------------------%

% count_board_pieces(+Board, +BCount, +WCount, -BCountOut, -WCountOut)
count_board_pieces([], BCount, WCount, BCount, WCount).

% count_board_pieces(+Board, +BCount, +WCount, -BCountOut, -WCountOut)
count_board_pieces([Row|Rest], BCountIn, WCountIn, BCountOut, WCountOut) :-
    count_board_pieces(Row, BCountIn, WCountIn, BCountMid, WCountMid),
    count_board_pieces(Rest, BCountMid, WCountMid, BCountOut, WCountOut).

% count_board_pieces(+Row, +BCount, +WCount, -BCountOut, -WCountOut), counts the number of black pieces on the board, incrementing BcountOut
count_board_pieces([board_piece(_, _, 'B', _, _)|Rest], BCountIn, WCountIn, BCountOut, WCountOut) :-
    BCountMid is BCountIn + 1,
    count_board_pieces(Rest, BCountMid, WCountIn, BCountOut, WCountOut).

% count_board_pieces(+Row, +BCount, +WCount, -BCountOut, -WCountOut), counts the number of white pieces on the board, incrementing WcountOut
count_board_pieces([board_piece(_, _, 'W', _, _)|Rest], BCountIn, WCountIn, BCountOut, WCountOut) :-
    WCountMid is WCountIn + 1,
    count_board_pieces(Rest, BCountIn, WCountMid, BCountOut, WCountOut).
    
count_board_pieces([_|Rest], BCountIn, WCountIn, BCountOut, WCountOut) :-
    count_board_pieces(Rest, BCountIn, WCountIn, BCountOut, WCountOut).
