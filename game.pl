% --------------- Refactoring ---------------

% Game State -> (Board, Turn)
% Move -> (Row, Column)-(MoveRow, MoveColumn)

display_game(GameState) :-
    GameState = (Board, Turn),
    format('Turn: ~w', [Turn]), nl, nl,
    display_board(Board).

initial_state(Size, GameState) :-
    % board is hardcoded 4x4, Size is not used
    initial_board(Board),
    GameState = (Board, red).

move(GameState, Move, NewGameState) :-
    GameState = (Board, Turn),
    Move = (Row, Column)-(MoveRow, MoveColumn),
    is_move_valid(GameState, Move),
    move_checker(Board, Move, NewBoard),
    switch_turn(Turn, NewTurn),
    NewGameState = (NewBoard, NewTurn).

is_move_valid(GameState, Move) :-
    GameState = (Board, Turn),
    Move = (Row, Column)-(MoveRow, MoveColumn),
    matrix_get(Board, Row, Column, Checker),
    Checker = Turn,
    is_orthogonal(Row, Column, MoveRow, MoveColumn),
    \+ matrix_get(Board, MoveRow, MoveColumn, empty).

is_orthogonal(R1, C, R2, C) :- R1 =:= R2 + 1.
is_orthogonal(R1, C, R2, C) :- R1 =:= R2 - 1.
is_orthogonal(R, C1, R, C2) :- C1 =:= C2 + 1.
is_orthogonal(R, C1, R, C2) :- C1 =:= C2 - 1.

move_checker(Board, Move, NewBoard) :-
    Move = (Row, Column)-(MoveRow, MoveColumn),
    matrix_get(Board, Row, Column, Checker),
    matrix_replace(Board, Row, Column, empty, MiddleBoard),
    matrix_replace(MiddleBoard, MoveRow, MoveColumn, Checker, NewBoard).

valid_moves(GameState, Moves) :-
    % may need to '^' the GameState
    findall(Move, valid_move(GameState, Move, _), Moves).

game_over(GameState, Winner) :-
    GameState = (Board, Turn),
    \+ matrix_member(Board, Turn),
    switch_turn(Turn, Winner).

% ----------------- Working -----------------

% To add:
% - Game state
% - Game over conditions
% - Valid moves
% - Move execution

% game-state -> playing, win, lose, draw
% state -> turn, against
% turn -> blue, red
% against -> human, computer

start_game(Turn-Against) :-
    initial_board(Board),
    switch_turn(Turn, StartTurn),
    game(playing, Board, StartTurn-Against).

switch_turn(blue, red).
switch_turn(red, blue).

game(playing, Board, Turn-Against) :-
    switch_turn(Turn, NewTurn),
    new_turn(Board, NewTurn-Against).

game(win, Board, Turn-Against) :-
    % TODO: add a pretty win screen (something like menu)
    clear,
    format('Player \'~w\' won!', [Turn]), nl, nl,
    write('Press \'1\' to return to main menu: '),
    read_number_between(1, 1, _),
    main_menu.

new_turn(Board, Turn-Against) :-
    clear,
    format('Turn: ~w', [Turn]), nl, nl,
    display_board(Board), nl,
    repeat,
    write('Choose a Row: '), read_number_between(0, 3, Row),
    write('Choose a Column: '), read_number_between(0, 3, Column),
    matrix_get(Board, Row, Column, Checker),
    (Checker = Turn ->
        nl, write('Correct Checker is working, validate moves from here'), nl, nl,
        repeat,
        (validate_move(Row, Column, MoveRow, MoveColumn) ->
            nl, write('Move is valid'), nl,
            execute_move(Board, Row, Column, MoveRow, MoveColumn, NewBoard),
            check_win(NewBoard, Turn, GameState), !,
            game(GameState, NewBoard, Turn-Against)
        ;
            nl, write('Move is invalid, Choose another move'), nl, nl, fail
        )
    ;
        nl, write('Invalid checker, Pick another coordinate'), nl, nl, fail
    ).


validate_move(Row, Column, MoveRow, MoveColumn) :-
    write('Choose a Row: '), read_number_between(0, 3, MoveRow),
    write('Choose a Column: '), read_number_between(0, 3, MoveColumn),
    % still missing validation about groups (maybe have a future board to check)
    (
        MoveRow =:= Row + 1, MoveColumn =:= Column
    ;
        MoveRow =:= Row - 1, MoveColumn =:= Column
    ;
        MoveRow =:= Row, MoveColumn =:= Column + 1
    ;
        MoveRow =:= Row, MoveColumn =:= Column - 1
    ).

execute_move(Board, Row, Column, MoveRow, MoveColumn, NewBoard) :-
    format('Moving from ~w, ~w to ~w, ~w', [Row, Column, MoveRow, MoveColumn]), nl,
    matrix_get(Board, Row, Column, Checker),
    matrix_replace(Board, Row, Column, empty, MiddleBoard),
    matrix_replace(MiddleBoard, MoveRow, MoveColumn, Checker, NewBoard).

check_win(Board, Turn, GameState) :-
    append(Board, FlatBoard),
    count_checkers(FlatBoard, blue, BlueCount),
    count_checkers(FlatBoard, red, RedCount), !,
    (BlueCount =:= 0 ->
        (Turn = blue ->
            GameState = lose
        ;
            GameState = win
        )
    ;
        RedCount =:= 0 ->
            (Turn = red ->
                GameState = lose
            ;
                GameState = win
            )
        ;
            true
    ).

count_checkers([], _, 0).
count_checkers([Checker|Rest], Checker, Count) :-
    count_checkers(Rest, Checker, RestCount),
    Count is RestCount + 1.

count_checkers([_|Rest], Checker, Count) :-
    count_checkers(Rest, Checker, Count).
