play :-
    initial_state(GameState-Player),
    display_game(GameState-Player).


    

instructions :-
    write(' _____________________________________________________________'), nl,
    write('|                     Stlts - Board Game                      |'), nl,
    write('|_____________________________________________________________|'), nl,
    write('|                        Instructions:                        |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|                                                             |'), nl,
    write('|_____________________________________________________________|'), nl,

    call(menu).

quit :-
    nl.

menu :-
    repeat,
    nl,
    write('Please select a number:'), nl,
    write_menu_list,
    read(OptionNumber),
    (   menu_option(OptionNumber, OptionName) ->  write('You selected: '), write(OptionName), nl, !;
        write('Not a valid choice, try again...'), nl, fail
    ),
    nl,
    call(OptionName).

write_menu_list :-
    menu_option(N, Name),
    write(N), write('. '), write(Name), nl,
    fail.
write_menu_list.

% menu_option(+OptionNumber, -Option)
menu_option(1, play).
menu_option(2, instructions).
menu_option(3, quit).
