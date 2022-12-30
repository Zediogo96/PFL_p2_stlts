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

% manage_piece_boat_hard(-Piece)
manage_piece_bot_hard(Piece) :-

    % Select the black piece that is closest to a white piece
    closest_black_piece(BlackRow, BlackColumn, WhiteRow, WhiteCol),

    %get the corresponding black piece
    get_board_piece(BlackRow, BlackColumn, Piece),

    % Calculate vertical and horizaontal distances to black piece (to check which pin should be added if no moves are possible)
    Vdis is abs(BlackRow-WhiteRow),
    Hdis is abs(BlackColumn-WhiteCol),
    
    % Get valid move destinations for the selected black piece
    get_valid_move_destinations(BlackRow, BlackColumn, MoveDestinations),

    (
        (BlackRow == WhiteRow, BlackColumn \= WhiteCol)->
        (member((WhiteRow,WhiteCol), MoveDestinations) -> move_board_piece(BlackRow, BlackColumn, WhiteRow, WhiteCol); increment_black_pin(BlackRow, BlackColumn))
        ;

        (BlackRow \= WhiteRow, BlackColumn == WhiteCol) ->
        (member((WhiteRow,WhiteCol), MoveDestinations) -> move_board_piece(BlackRow, BlackColumn, WhiteRow, WhiteCol); increment_white_pin(BlackRow, BlackColumn))
        ;
        (BlackRow \= WhiteRow, BlackColumn \= WhiteCol) ->
        %check if Hdis is greater or equal than Vdis 
        (Hdis >= Vdis -> (member((WhiteRow, BlackCol), MoveDestinations) -> move_board_piece(BlackRow, BlackColumn, WhiteRow, BlackCol); increment_white_pin(BlackRow, BlackColumn)); (member((BlackRow, WhiteCol), MoveDestinations) -> move_board_piece(BlackRow, BlackColumn, BlackRow, WhiteCol); increment_black_pin(BlackRow, BlackColumn)))
  
    ).

% closest_black_piece(-RowNum, -ColNum)
closest_black_piece(RowNum, ColNum, WhiteRow, WhiteCol) :-
    findall((X-Y-Dist), (member(X, [1,2,3,4,5,6,7,8,9,10,11,12]), member(Y, [1,2,3,4,5,6,7,8,9,10,11,12]),get_board_piece(X, Y, board_piece(X, Y, 'B', _, _)), distance_to_white_piece(X, Y, Dist)), L),
    sort_list_by_dist(L, SortedList),
    nth1(1, SortedList, (RowNum-ColNum-Dist)),
    arg(1, Dist, Temp),
    arg(1, Temp, WhiteRow), arg(2, Temp, WhiteCol),
    arg(2, Dist, D),
    write('White Piece is: '), write(WhiteRow), write('-'), write(WhiteCol), nl,
    write('Distance is: '), write(D), nl.

% distance_to_white_piece(+RowNum, +ColNum, -Distance)
distance_to_white_piece(RowNum, ColNum,  Distance) :-
    % write('Black Piece at: '), write(RowNum), write('-'), write(ColNum), nl,
    findall(X-Y, (member(X, [1,2,3,4,5,6,7,8,9,10,11,12]), member(Y, [1,2,3,4,5,6,7,8,9,10,11,12]), get_board_piece(X, Y, board_piece(X, Y, 'W', _, _))), WhitePieces),
    maplist(distance(RowNum, ColNum), WhitePieces, Distances),
    % sort the list of distances in ascending order
    sort_list_by_dist(Distances, SortedList),
    % get the first element of the sorted list
    nth1(1, SortedList, Distance).
    
% distance(+RowNum, +ColNum, +WhitePiece, -Distance)
distance(RowNum, ColNum, X-Y, X-Y-Distance) :-
    % write('White Piece at: '), write(X), write('-'), write(Y), write(' '), write('Distance: '),
    Distance is sqrt((RowNum - X)^2 + (ColNum - Y)^2).

% sort_list_by_dist(+List, -SortedList)
sort_list_by_dist(List, SortedList) :-
    sort_list_by_dist(List, [], SortedList).

% sort_list_by_dist(+List, +Acc, -SortedList)
sort_list_by_dist([], Acc, Acc).
sort_list_by_dist([X-Y-Dist|T], Acc, SortedList) :-
    insert_sorted(X-Y-Dist, Acc, Acc1),
    sort_list_by_dist(T, Acc1, SortedList).

% insert_sorted(+Elem, +List, -SortedList)
insert_sorted(X-Y-Dist, [], [X-Y-Dist]).
insert_sorted(X-Y-Dist, [X1-Y1-Dist1|T], [X-Y-Dist,X1-Y1-Dist1|T]) :-
    Dist < Dist1.
insert_sorted(X-Y-Dist, [X1-Y1-Dist1|T], [X1-Y1-Dist1|T1]) :-
    Dist >= Dist1,
    insert_sorted(X-Y-Dist, T, T1).
