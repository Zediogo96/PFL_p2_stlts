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




