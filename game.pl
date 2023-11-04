% -------------------- IO --------------------

read_row(Row) :-
    write('Row: '),
    read_number_between(0, 3, Row), !.

read_row(Row) :-
    write('Invalid Row, try again'), nl,
    read_row(Row).

read_column(Column) :-
    write('Column: '),
    read_number_between(0, 3, Column), !.

read_column(Column) :-
    write('Invalid column, try again'), nl,
    read_column(Column).

% --------------- Refactoring ---------------

% Game State -> (Board, Turn)
% Move -> (Row, Column)-(MoveRow, MoveColumn)

switch_turn(blue, red).
switch_turn(red, blue).

display_game(GameState) :-
    clear,
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

is_orthogonal(R1, C, R2, C) :- R2 is R1 + 1.
is_orthogonal(R1, C, R2, C) :- R2 is R1 - 1.
is_orthogonal(R, C1, R, C2) :- C2 is C1 + 1.
is_orthogonal(R, C1, R, C2) :- C2 is C1 - 1.

move_checker(Board, Move, NewBoard) :-
    Move = (Row, Column)-(MoveRow, MoveColumn),
    matrix_get(Board, Row, Column, Checker),
    matrix_replace(Board, Row, Column, empty, MiddleBoard),
    matrix_replace(MiddleBoard, MoveRow, MoveColumn, Checker, NewBoard).

valid_moves(GameState, Moves) :-
    findall(Move, move(GameState, Move, _), Moves).

game_over(GameState, Winner) :-
    GameState = (Board, Turn),
    \+ matrix_member(Board, Turn),
    switch_turn(Turn, Winner).

% To have some parameter to know type of game (player vs player, player vs computer)
start_game :-
    initial_state(4, GameState),
    display_game(GameState),
    game_loop(GameState).

game_loop(GameState) :-
    game_over(GameState, Winner),
    nl, format('Game over! Winner: ~w', [Winner]), nl, nl,
    write('Press 1 to exit: '),
    read_number_between(1, 1, _), main_menu.

game_loop(GameState) :-
    nl, choose_move(Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState).

game_loop(GameState) :-
    nl, write('Invalid move, try again'), nl,
    game_loop(GameState).

choose_move((Row, Column)-(MoveRow, MoveColumn)) :-
    write('Choose a checker to move'), nl,
    read_row(Row),
    read_column(Column),
    nl, write('Choose a place to move'), nl,
    read_row(MoveRow),
    read_column(MoveColumn).
