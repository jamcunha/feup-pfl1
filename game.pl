% To add:
% - Game state
% - Game over conditions
% - Valid moves
% - Move execution

% state -> turn, against
% turn -> blue, red
% against -> human, computer

start_game(Turn-Against) :-
    clear,
    initial_board(Board),
    % have a predicate to start the game accounting against
    format('Turn: ~w~n', [Turn]), nl,
    display_board(Board), nl,
    repeat,
    write('Choose a Row: '), read_number_between(0, 3, Row),
    write('Choose a Column: '), read_number_between(0, 3, Column),
    matrix_get(Board, Row, Column, Checker),
    (Checker = Turn ->
        nl, write('Correct Checker is working, validate moves from here'), nl, nl,
        repeat,
        (move(Row, Column) ->
            nl, write('Move is valid'), nl
        ;
            nl, write('Move is invalid, Choose another move'), nl, nl, fail
        )
    ;
        nl, write('Invalid checker, Pick another coordinate'), nl, nl, fail
    ).

move(Row, Column) :-
    write('Choose a Row: '), read_number_between(0, 3, MoveRow),
    write('Choose a Column: '), read_number_between(0, 3, MoveColumn),
    validate_move(Row, Column, MoveRow, MoveColumn).
    %? execute_move(Row, Column, MoveRow, MoveColumn)

validate_move(Row, Column, MoveRow, MoveColumn) :-
    % still missing validation about groups (maybe have a future board to check)
    MoveRow =:= Row + 1, MoveColumn =:= Column;
    MoveRow =:= Row - 1, MoveColumn =:= Column;
    MoveRow =:= Row, MoveColumn =:= Column + 1;
    MoveRow =:= Row, MoveColumn =:= Column - 1.
