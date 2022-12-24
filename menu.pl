play :-
    initial_state(GameState-Player),
    display_game(GameState-Player), nl,
    manage_piece(Piece),
    display_game(GameState-Player), nl.

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


% manage_piece(-Piece)
manage_piece(Piece) :-
    repeat,
    % get valid row and column input from the user
    get_valid_row_column_input(Row, Column),
    % select the piece with the specified row and column
    get_board_piece(Row, Column, Piece),
    % check if the selected piece is not empty
    Piece = board_piece(PieceRN, PieceCN, Type, _, _),
    (Type \= ' ' -> 
    % display the menu of options
    write('1. Increment white pin'), nl,
    write('2. Increment black pin'), nl,
    write('3. Move'), nl,
    write('4. Back to get_valid_row_column_input'), nl,
    % get option input from the user
    write('Enter option: '),
    read(Option),
    % execute the chosen option
    (Option = 1 ->
     % increment white pin
     increment_white_pin(PieceRN, PieceCN)
     ;
     Option = 2 ->
     % increment black pin
     increment_black_pin(PieceRN, PieceCN)
     ;
     Option = 3 ->
     % move the piece
      write('NOT IMPLEMENTED')
     ;
     Option = 4 ->
        % back to get_valid_row_column_input
        manage_piece(Piece), true
     ;
     % invalid option, print an error message and repeat
     write('Error: invalid option.'), nl,
     manage_piece(Piece));
    
     % the selected piece is empty, print an error message and repeat
     write('Error: the selected piece is empty.'), nl,
     nl, fail).

