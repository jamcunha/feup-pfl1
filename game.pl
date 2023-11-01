% To add:
% - Game state
% - Game over conditions
% - Valid moves
% - Move execution

% state -> turn, against
% turn -> blue, red
% against -> human, computer

start_game(Turn-Against) :-
    initial_board(Board),
    new_turn(Board, Turn-Against).

switch_turn(blue, red).
switch_turn(red, blue).

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
            switch_turn(Turn, NewTurn),
            new_turn(NewBoard, NewTurn-Against)
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
    format('Checker is ~w', [Checker]), nl,
    matrix_replace(Board, Row, Column, empty, MiddleBoard),
    matrix_replace(MiddleBoard, MoveRow, MoveColumn, Checker, NewBoard).
