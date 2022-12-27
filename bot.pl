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

% manage_piece(-Piece)
manage_piece_bot_easy(Piece) :-

    % Select a random black piece

    select_random_black_piece(Row, Column),

    get_valid_move_destinations(Row, Column, MoveDestinations),

    length(MoveDestinations, NumValidDestinations),
        (NumValidDestinations > 0 -> 
        get_random_destination(MoveDestinations, TR, TC),
        move_board_piece(Row, Column, TR, TC), nl, format('Bot moved piece from (~w,~w) to (~w,~w)', [Row, Column, TR, TC]), nl; 
        random(0, 2, Random),
        (Random = 0 -> increment_white_pin(Row,Column), nl, format('Bot added white pin to piece in (~w,~w)', [Row, Column]), nl; increment_black_pin(Row,Column), nl, format('Bot added black pin to piece in (~w,~w)', [Row, Column]), nl)
        ).
