% HELPER FUNCTIONS

is_between(Lower, Upper, X) :-
    Lower =< Upper,
    Lower =< X,
    X =< Upper.

% char_to_int(+Char, -Int)
char_to_int(Char, Int) :-
    char_code(Char, Code),
    Int is Code - 96.

% int_to_char(+Int, -Char)
int_to_char(Int, Char) :-
Code is Int + 96,
char_code(Char, Code).

% select_random_black_piece(-RowNum, -ColNum)
select_random_black_piece(RowNum, ColNum) :-
    findall(Row-Col, (member(Row, [1,2,3,4,5,6,7,8,9,10,11,12]), member(Col, [1,2,3,4,5,6,7,8,9,10,11,12]), get_board_piece(Row, Col, board_piece(_, _, 'B', _, _))), BlackPieces),
    length(BlackPieces, NumBlackPieces),
    random(1, NumBlackPieces, RandomIndex),
    nth1(RandomIndex, BlackPieces, RowNum-ColNum).

get_random_destination(MoveDestinations, TR, TC) :-
    length(MoveDestinations, NumDestinations),
    random(0, NumDestinations, Index),
    nth0(Index, MoveDestinations, RandomDestination),
    (TR, TC) = RandomDestination.
    
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

count_board_pieces([Row|Rest], BCountIn, WCountIn, BCountOut, WCountOut) :-
    count_board_pieces(Row, BCountIn, WCountIn, BCountMid, WCountMid),
    count_board_pieces(Rest, BCountMid, WCountMid, BCountOut, WCountOut).

count_board_pieces([board_piece(_, _, 'B', _, _)|Rest], BCountIn, WCountIn, BCountOut, WCountOut) :-
    BCountMid is BCountIn + 1,
    count_board_pieces(Rest, BCountMid, WCountIn, BCountOut, WCountOut).

count_board_pieces([board_piece(_, _, 'W', _, _)|Rest], BCountIn, WCountIn, BCountOut, WCountOut) :-
    WCountMid is WCountIn + 1,
    count_board_pieces(Rest, BCountIn, WCountMid, BCountOut, WCountOut).
    
count_board_pieces([_|Rest], BCountIn, WCountIn, BCountOut, WCountOut) :-
    count_board_pieces(Rest, BCountIn, WCountIn, BCountOut, WCountOut).
