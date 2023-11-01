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
    % have a predicate to start the game with accounting against
    format('Turn: ~w~n', [Turn]), nl,
    display_board(Board), nl,
    choose_piece(Board, Turn-Against).

choose_piece(Board, Turn-Against) :-
    repeat,
    write('Choose a Row: '), read_number_between(0, 3, Row),
    write('Choose a Column: '), read_number_between(0, 3, Column),
    matrix_get(Board, Row, Column, Checker),
    (Checker = Turn ->
        write('Correct Checker is working, validate moves from here'), nl
    ;
        nl, write('Invalid move'), nl, nl, fail
    ).
