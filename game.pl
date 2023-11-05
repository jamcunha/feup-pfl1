:- use_module(library(random)).

% Game State -> (Board, Turn)
% Move -> (Row, Column)-(MoveRow, MoveColumn)

read_row(Row, Size) :-
    write('Row: '),
    Temp is Size - 1,
    read_number_between(0, Size, Row), !.

read_row(Row, Size) :-
    write('Invalid Row, try again'), nl,
    read_row(Row, Size).

read_column(Column, Size) :-
    write('Column: '),
    Temp is Size - 1,
    read_number_between(0, Temp, Column), !.

read_column(Column, Size) :-
    write('Invalid column, try again'), nl,
    read_column(Column, Size).

switch_turn(blue, red).
switch_turn(red, blue).

display_game(GameState) :-
    clear,
    GameState = (Board, Turn, Size),
    format('Turn: ~w', [Turn]), nl, nl,
    display_board(Board, Size).

initial_state(Size, GameState) :-
    initial_board(Size, Board),
    GameState = (Board, red, Size).

move(GameState, Move, NewGameState) :-
    GameState = (Board, Turn, Size),
    Move = (Row, Column)-(MoveRow, MoveColumn),
    is_move_valid(GameState, Move),
    move_checker(Board, Move, NewBoard),
    switch_turn(Turn, NewTurn),
    NewGameState = (NewBoard, NewTurn, Size).

is_move_valid(GameState, Move) :-
    GameState = (Board, Turn, _),
    Move = (Row, Column)-(MoveRow, MoveColumn),
    matrix_get(Board, Row, Column, Checker),
    Checker = Turn,
    is_orthogonal(Row, Column, MoveRow, MoveColumn),
    \+ matrix_get(Board, MoveRow, MoveColumn, empty).

move_checker(Board, Move, NewBoard) :-
    Move = (Row, Column)-(MoveRow, MoveColumn),
    matrix_get(Board, Row, Column, Checker),
    matrix_replace(Board, Row, Column, empty, MiddleBoard),
    matrix_replace(MiddleBoard, MoveRow, MoveColumn, Checker, NewBoard).

valid_moves(GameState, Moves) :-
    findall(Move, move(GameState, Move, _), Moves).

game_over(GameState, Winner) :-
    GameState = (Board, Turn, _),
    \+ matrix_member(Board, Turn),
    switch_turn(Turn, Winner).

% To have some parameter to know type of game (player vs player, player vs computer)
start_game(Size) :-
    initial_state(Size, GameState),
    display_game(GameState),
    game_loop(GameState).

game_loop(GameState) :-
    game_over(GameState, Winner),
    GameState = (Board, _, Size),
    clear,
    display_board(Board, Size),
    nl, format('Game over! Winner: ~w', [Winner]), nl, nl,
    write('Press 1 to exit: '),
    read_number_between(1, 1, _), main_menu.

game_loop(GameState) :-
    valid_moves(GameState, Moves),
    Moves = [],
    GameState = (Board, Turn, Size),
    switch_turn(Turn, NewTurn),
    TempGameState = (Board, NewTurn, Size),
    valid_moves(TempGameState, NewMoves),
    NewMoves = [],
    clear,
    clear,
    display_board(Board, Size),
    nl, write('No more legal moves. Draw!'), nl,
    write('Press 1 to exit: '),
    read_number_between(1, 1, _), main_menu.

game_loop(GameState) :-
    valid_moves(GameState, Moves),
    Moves = [],
    write('No more legal moves. Skipping turn'), nl,
    write('Press 1 to continue: '),
    read_number_between(1, 1, _),
    GameState = (Board, Turn, Size),
    switch_turn(Turn, NewTurn),
    game_loop((Board, NewTurn, Size)).

game_loop(GameState) :-
    nl, choose_move(GameState, Move, c),
    % read_number_between(1, 1, _),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState).

game_loop(GameState) :-
    nl, write('Invalid move, try again'), nl,
    game_loop(GameState).

choose_move((_, _, Size), (Row, Column)-(MoveRow, MoveColumn), p) :-
    write('Choose a checker to move'), nl,
    read_row(Row, Size),
    read_column(Column, Size),
    nl, write('Choose a place to move'), nl,
    read_row(MoveRow, Size),
    read_column(MoveColumn, Size).

choose_move(GameState, Move, c) :-
    % TODO: Problem when there are no valid moves
    valid_moves(GameState, Moves),
    random_member(Move, Moves),
    format('Computer chose: ~w', [Move]), nl.
