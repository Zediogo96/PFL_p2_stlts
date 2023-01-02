% select_random_black_piece(-RowNum, -ColNum)
select_random_black_piece(RowNum, ColNum) :-
    % Find all black pieces on the board and store their coordinates in BlackPieces.
    findall(Row-Col, (member(Row, [1,2,3,4,5,6,7,8,9,10,11,12]), member(Col, [1,2,3,4,5,6,7,8,9,10,11,12]), get_board_piece(Row, Col, board_piece(_, _, 'B', _, _))), BlackPieces),
    length(BlackPieces, NumBlackPieces),
    random(1, NumBlackPieces, RandomIndex),
    % Find the RandomIndex-th element of BlackPieces and unify it with RowNum-ColNum.
    nth1(RandomIndex, BlackPieces, RowNum-ColNum).

% get_random_destination(+MoveDestinations, -TR, -TC)
get_random_destination(MoveDestinations, TR, TC) :-
    % Find the number of elements in the list of destinations.
    length(MoveDestinations, NumDestinations),
    random(0, NumDestinations, Index),
    % Find the Index-th element of MoveDestinations and unify it with RandomDestination.
    nth0(Index, MoveDestinations, RandomDestination),
    % Unify TR and TC with the coordinates of RandomDestination.
    (TR, TC) = RandomDestination.

% manage_piece(-Piece)
manage_piece_bot_easy(Piece) :-
    % Select a random black piece
    select_random_black_piece(Row, Column),
    % Get it's valids moves
    valid_moves(Row, Column, MoveDestinations),
    % If it has valid moves, move it to a random valid destination, otherwise add a random pin
    length(MoveDestinations, NumValidDestinations),
        (NumValidDestinations > 0 -> 
        get_random_destination(MoveDestinations, TR, TC),
        move(Row, Column, TR, TC), nl, format('Bot moved piece from (~w,~w) to (~w,~w)', [Row, Column, TR, TC]), nl; 
        random(0, 2, Random),
        (Random = 0 -> increment_white_pin(Row,Column), nl, format('Bot added white pin to piece in (~w,~w)', [Row, Column]), nl; increment_black_pin(Row,Column), nl, format('Bot added black pin to piece in (~w,~w)', [Row, Column]), nl)
        ).

% manage_piece_boat_hard(-Piece)
manage_piece_bot_hard(TypePlay) :-

    % Select the black piece that is closest to a white piece
    bot_choose_closest_piece(TypePlay, CurrRow, CurrColumn, TargetRow, TargetCol),
    %get the corresponding black piece
    get_board_piece(CurrRow, CurrColumn, Piece),
    % Calculate vertical and horizaontal distances to black piece (to check which pin should be added if no moves are possible)
    Vdis is abs(CurrRow-TargetRow),
    Hdis is abs(CurrColumn-TargetCol),
    % Get valid move destinations for the selected black piece
    valid_moves(CurrRow, CurrColumn, MoveDestinations),
    (
        (CurrRow == TargetRow, CurrColumn \= TargetCol)->
        (member((TargetRow,TargetCol), MoveDestinations) -> 
        move(CurrRow, CurrColumn, TargetRow, TargetCol), nl, format('Bot moved piece from (~w,~w) to (~w,~w)', [CurrRow, CurrColumn, TargetRow, TargetCol]), nl;
        increment_black_pin(CurrRow, CurrColumn), nl, format('Bot added black pin to piece in (~w,~w)', [CurrRow, CurrColumn]), nl
        )
        ;
        (CurrRow \= TargetRow, CurrColumn == TargetCol) ->
        (member((TargetRow,TargetCol), MoveDestinations) -> 
        move(CurrRow, CurrColumn, TargetRow, TargetCol), nl, format('Bot moved piece from (~w,~w) to (~w,~w)', [CurrRow, CurrColumn, TargetRow, TargetCol]), nl;
        increment_white_pin(CurrRow, CurrColumn), nl, format('Bot added white pin to piece in (~w,~w)', [CurrRow, CurrColumn]), nl
        )
        ;
        (CurrRow \= TargetRow, CurrColumn \= TargetCol) ->
        %check if Hdis is greater or equal than Vdis 
        (Hdis >= Vdis -> 
        (member((TargetRow, CurrCol), MoveDestinations) -> move(CurrRow, CurrColumn, TargetRow, CurrCol), format('Bot moved piece from (~w,~w) to (~w,~w)', [CurrRow, CurrColumn, TargetRow, CurrCol]), nl; increment_white_pin(CurrRow, CurrColumn), nl, format('Bot added white pin to piece in (~w,~w)', [CurrRow, CurrColumn]), nl); 
        (member((CurrRow, TargetCol), MoveDestinations) -> move(CurrRow, CurrColumn, CurrRow, TargetCol), format('Bot moved piece from (~w,~w) to (~w,~w)', [CurrRow, CurrColumn, CurrRow, TargetCol]), nl; increment_black_pin(CurrRow, CurrColumn), nl, format('Bot added black pin to piece in (~w,~w)', [CurrRow, CurrColumn]), nl))
    ).

% bot_choose_closest_piece(+TypePlay, -RowNum, -ColNum, -TargetRow, -TargetCol)
bot_choose_closest_piece(TypePlay, RowNum, ColNum, TargetRow, TargetCol) :-
    findall((X-Y-Dist), (member(X, [1,2,3,4,5,6,7,8,9,10,11,12]), member(Y, [1,2,3,4,5,6,7,8,9,10,11,12]),get_board_piece(X, Y, board_piece(X, Y, TypePlay, _, _)), distance_to_other_piece_type(TypePlay, X, Y, Dist)), L),
    sort_list_by_dist(L, SortedList),
    reverse(SortedList, ReversedList),
    nth1(1, ReversedList, (RowNum-ColNum-Other)),
    arg(1, Other, Temp),
    arg(1, Temp, TargetRow), arg(2, Temp, TargetCol),
    arg(2, Other, D).

% distance_to_other_piece_type(+RowNum, +ColNum, -Distance)
distance_to_other_piece_type(TypePlay, RowNum, ColNum,  Distance) :-
    % if typePlay is 'B', set typeTarget to 'W', otherwise set it to 'B'
    (TypePlay = 'B' -> TypeTarget = 'W'; TypeTarget = 'B'),
    % write('Black Piece at: '), write(RowNum), write('-'), write(ColNum), nl,
    findall(X-Y, (member(X, [1,2,3,4,5,6,7,8,9,10,11,12]), member(Y, [1,2,3,4,5,6,7,8,9,10,11,12]), get_board_piece(X, Y, board_piece(X, Y, TypeTarget, _, _))), Pieces),
    maplist(distance(RowNum, ColNum), Pieces, Distances),
    % sort the list of distances in ascending order
    sort_list_by_dist(Distances, SortedList),
    % get the first element of the sorted list
    nth1(1, SortedList, Distance).
    
% distance(+RowNum, +ColNum, +WhitePiece, -Distance)
distance(RowNum, ColNum, X-Y, X-Y-Distance) :-
    % write('White Piece at: '), write(X), write('-'), write(Y), write(' '), write('Distance: '),
    Distance is max(abs(RowNum-X), abs(ColNum-Y) + 0.01).

% sort_list_by_dist(+List, -SortedList)
sort_list_by_dist(List, SortedList) :-
    sort_list_by_dist(List, [], SortedList).

% sort_list_by_dist(+List, +Acc, -SortedList), sorts the list by distance in ascending order
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
