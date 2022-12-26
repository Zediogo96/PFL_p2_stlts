play_pvp :-
    initial_state(GameState-Player),
    game_loop(GameState-Player).

% AINDA PARA MODO DEBUG
play_bot :-
    initial_state(GameState-Player),
    display_game(GameState-Player), nl.


game_loop(GameState-Player) :-
    
    repeat,
    game_over(Winner),
    (Winner \= None ->
     % game is over, display the final game state and stop looping
     display_game(GameState-Player), nl,
     write('Game over! Winner: '), write(Winner), nl
     ;
     % game is not over, display the current game state and allow the player to make a move
     display_game(GameState-Player), nl,
     manage_piece(Piece, Player),
     % set player to the next player
     (Player = player1 -> NextPlayer = player2; NextPlayer = player1)),
     game_loop(GameState-NextPlayer).

instructions :-
    write(' _____________________________________________________________'), nl,
    write('|                     Stlts - Board Game                      |'), nl,
    write('|_____________________________________________________________|'), nl,
    write('|                        Instructions:                        |'), nl,
    write('|                                                             |'), nl,
    write('| STLTS (pronounced "stalts") is a two-player board game      |'), nl,
    write('| played on a 12x12 board. Each player has a set of white and |'), nl,
    write('| black game pieces, with the goal of capturing all the       |'), nl,
    write('| opponent pieces.                                            |'), nl,
    write('|                                                             |'), nl,
    write('| Pieces can only move horizontally or vertically, and the    |'), nl,
    write('| number of cells moved is represented by its pins:           |'), nl,
    write('|     - 1 white pin means it can move 1 cell vertically       |'), nl,
    write('|     - 2 black pins means it can move 2 cells horizontally   |'), nl,
    write('|                                                             |'), nl,
    write('| Movement must also be exact:                                |'), nl,
    write('|     In order to move from A to B, every cell between the    |'), nl,
    write('|     two cells must be empty (cant have neither your pieces, |'), nl,
    write('|     neither your opponents ones.                            |'), nl,
    write('|                                                             |'), nl,
    write('| Each turn a player can:                                     |'), nl,
    write('|     - Add a white or black pin to one of its pieces.        |'), nl,
    write('|     - Move on of its pieces                                 |'), nl,
    write('|                                                             |'), nl,
    write('|_____________________________________________________________|'), nl,

    call(menu).

quit :-
    nl.

% logo/0, prints the game logo.
logo:-
nl,nl,nl,nl,
write('**************************************************'),nl,
write('*  @@@@@@@@ @@@@@@@@  @@    @@@@@@@@  @@@@@@@@   *'),nl,
write('*  @@          @@     @@       @@     @@         *'),nl,
write('*  @@          @@     @@       @@     @@         *'),nl,
write('*  @@@@@@@@    @@     @@       @@     @@@@@@@@   *'),nl,
write('*        @@    @@     @@       @@           @@   *'),nl,
write('*        @@    @@     @@       @@           @@   *'),nl,
write('*  @@@@@@@@    @@     @@@@@@@  @@     @@@@@@@@   *'),nl,
write('**************************************************'),nl,nl.

menu :-
    repeat,
    nl,
    logo,
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
menu_option(1, play_pvp).
menu_option(2, play_bot).
menu_option(3, instructions).
menu_option(4, quit).

% manage_piece(-Piece)
manage_piece(Piece, Player) :-
    repeat,
    % get valid row and column input from the user
    get_valid_row_column_input(Row, Column),
    % select the piece with the specified row and column
    get_board_piece(Row, Column, Piece),
    % check if the selected piece is not empty
    Piece = board_piece(PieceRN, PieceCN, Type, _, _),
    % Player should only be able to select pieces of his color
    (
    Player = player1, Type = 'W' -> true;
    Player = player2, Type = 'B' -> true;
    % selected piece is not the same color as the player, print an error message and repeat
     write('Error: Selected piece is not the same color as the current player.'), nl,
     fail
    ),
    (Type \= ' ' -> 
    % display the menu of options
    nl,
    write('1. Increment white pin'), nl,
    write('2. Increment black pin'), nl,
    write('3. Move'), nl,
    write('4. Back to Select Piece'), nl,
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
      get_valid_move_destinations(PieceRN, PieceCN, ValidDestinations),
      print_valid_move_destinations(ValidDestinations),
      select_valid_move_destination(PieceToRN, PieceToCN, ValidDestinations),
      move_board_piece(PieceRN, PieceCN, PieceToRN, PieceToCN)
     ;
     Option = 4 ->
        % back to get_valid_row_column_input
        manage_piece(Piece, Player), true
     ;
     % invalid option, print an error message and repeat
     write('Error: invalid option.'), nl,
     manage_piece(Piece, Player));
    
     % the selected piece is empty, print an error message and repeat
     write('Error: the selected piece is empty.'), nl,
     nl, fail).

% get_valid_row_column_input(-Row, -Column)
get_valid_row_column_input(Row, Column) :-
    repeat,
    % get row input from the user
    write('Choose your Piece: '), nl,
    write('   -- Enter row number: '),
    read(InputRow),
    % check if the input is a valid row index
    (is_between(1, 12, InputRow) ->
     Row = InputRow,
     % get column input from the user
     write('   -- Enter column letter: '),
     read(InputChar),
     char_to_int(InputChar, InputColumn),
     % check if the input is a valid column index
     (is_between(1, 12, InputColumn) ->
      Column = InputColumn,
      % input is valid, stop repeating
      !
      ;
      % input is not a valid column index, print an error message and repeat
      write('Error: invalid column index. Column index must be between 1 and 12.'), nl,
      fail)
     ;
     % input is not a valid row index, print an error message and repeat
     write('Error: invalid row index. Row index must be between 1 and 12.'), nl,
     fail).

% print_valid_move_destinations(+ValidDestinations)
print_valid_move_destinations(ValidDestinations) :-
    length(ValidDestinations, NumValidDestinations), nl,
    (NumValidDestinations =:= 0 -> 
    write('There are no valid destinations for this piece.'), nl, fail;
    format('There are ~w valid destinations for this piece:\n', [NumValidDestinations]), nl,
    helper_print_valid_moves(ValidDestinations, 1)).

% print_valid_move_destinations(+ValidDestinations, +Num)
helper_print_valid_moves([], _).
helper_print_valid_moves([(ToRowNum, ToColumnNum)|ValidDestinations], Num) :-
    format('~w. (~w, ~w)\n', [Num, ToRowNum, ToColumnNum]),
    Num1 is Num + 1,
    helper_print_valid_moves(ValidDestinations, Num1).

% select_valid_move_destination(-ToRowNum, -ToColumnNum, +ValidDestinations)
select_valid_move_destination(ToRowNum, ToColumnNum, ValidDestinations) :-
    write('Enter destination number: '),
    read(Selection),
    nth1(Selection, ValidDestinations, (ToRowNum, ToColumnNum)).


