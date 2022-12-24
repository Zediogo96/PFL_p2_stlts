% HELPER FUNCTIONS

is_between(Lower, Upper, X) :-
    Lower =< Upper,
    Lower =< X,
    X =< Upper.
    
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
