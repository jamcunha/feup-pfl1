:- use_module(library(random)).

% Game State -> (Board, Turn)
% Move -> (Row, Column)-(MoveRow, MoveColumn)

/**
 * read_row/2
 * read_row(-Row, +Size)
 *
 * Reads a row from the user and checks if it is valid
 */
read_row(Row, Size) :-
    write('Row: '),
    Temp is Size - 1,
    read_number_between(0, Size, Row), !.

read_row(Row, Size) :-
    write('Invalid Row, try again'), nl,
    read_row(Row, Size).

/**
 * read_column/2
 * read_column(-Column, +Size)
 *
 * Reads a column from the user and checks if it is valid
 */
read_column(Column, Size) :-
    write('Column: '),
    Temp is Size - 1,
    read_number_between(0, Temp, Column), !.

read_column(Column, Size) :-
    write('Invalid column, try again'), nl,
    read_column(Column, Size).

/**
 * switch_turn/2
 * switch_turn(+Turn, -NewTurn)
 *
 * Switches the turn
 */
switch_turn(blue, red).
switch_turn(red, blue).

/**
 * display_game/1
 * display_game(+GameState)
 *
 * Displays the board and the current turn
 */
display_game(GameState) :-
    clear,
    GameState = (Board, Turn, Size),
    format('Turn: ~w', [Turn]), nl, nl,
    display_board(Board, Size).

/**
 * initial_state/2
 * initial_state(+Size, -GameState)
 *
 * Creates the initial game state
 */
initial_state(Size, GameState) :-
    initial_board(Size, Board),
    GameState = (Board, red, Size).

/**
 * move/3
 * move(+GameState, +Move, -NewGameState)
 *
 * Validates and executes a move
 */
move(GameState, Move, NewGameState) :-
    GameState = (Board, Turn, Size),
    Move = (Row, Column)-(MoveRow, MoveColumn),
    is_move_valid(GameState, Move),
    move_checker(Board, Move, NewBoard),
    switch_turn(Turn, NewTurn),
    NewGameState = (NewBoard, NewTurn, Size).

/**
 * is_move_valid/2
 * is_move_valid(+GameState, +Move)
 *
 * Checks if a move is valid
 */
is_move_valid(GameState, Move) :-
    GameState = (Board, Turn, _),
    Move = (Row, Column)-(MoveRow, MoveColumn),
    matrix_get(Board, Row, Column, Checker),
    Checker = Turn,
    is_orthogonal(Row, Column, MoveRow, MoveColumn),
    \+ matrix_get(Board, MoveRow, MoveColumn, empty).

/**
 * move_checker/3
 * move_checker(+Board, +Move, -NewBoard)
 *
 * Moves a checker
 */
move_checker(Board, Move, NewBoard) :-
    Move = (Row, Column)-(MoveRow, MoveColumn),
    matrix_get(Board, Row, Column, Checker),
    matrix_replace(Board, Row, Column, empty, MiddleBoard),
    matrix_replace(MiddleBoard, MoveRow, MoveColumn, Checker, NewBoard).

/**
 * valid_moves/2
 * valid_moves(+GameState, -Moves)
 *
 * Finds all valid moves for a given game state
 */
valid_moves(GameState, Moves) :-
    findall(Move, move(GameState, Move, _), Moves).

/**
 * game_over/2
 * game_over(+GameState, -Winner)
 *
 * Checks if the game is over with winning conditions
 */
game_over(GameState, Winner) :-
    GameState = (Board, Turn, _),
    \+ matrix_member(Board, Turn),
    switch_turn(Turn, Winner).

/**
 * start_game/2
 * start_game(+Size, +GameType)
 *
 * Starts a game
 */
start_game(Size, P1-P2) :-
    initial_state(Size, GameState),
    display_game(GameState),
    random_member(FirstPlayer, [P1, P2]),
    game_loop(GameState, P1-P2, FirstPlayer).

/**
 * game_loop/3
 * game_loop(+GameState, +GameType, +Player)
 *
 * Main game loop, player is the current player (player or computer)
 */
game_loop(GameState, _, _) :-
    game_over(GameState, Winner),
    GameState = (Board, _, Size),
    clear,
    display_board(Board, Size),
    nl, format('Game over! Winner: ~w', [Winner]), nl, nl,
    write('Press 1 to exit: '),
    read_number_between(1, 1, _), main_menu.

game_loop(GameState, _, _) :-
    valid_moves(GameState, Moves),
    Moves = [],
    GameState = (Board, Turn, Size),
    switch_turn(Turn, NewTurn),
    TempGameState = (Board, NewTurn, Size),
    valid_moves(TempGameState, NewMoves),
    NewMoves = [],
    clear,
    display_board(Board, Size),
    nl, write('No more legal moves. Draw!'), nl,
    write('Press 1 to exit: '),
    read_number_between(1, 1, _), main_menu.

game_loop(GameState, GameType, Player) :-
    valid_moves(GameState, Moves),
    Moves = [],
    write('No more legal moves. Skipping turn'), nl,
    write('Press 1 to continue: '),
    read_number_between(1, 1, _),
    GameState = (Board, Turn, Size),
    switch_turn(Turn, NewTurn),
    game_loop((Board, NewTurn, Size), GameType, Player).

game_loop(GameState, p-p, _) :-
    nl, choose_move(GameState, p, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, p-p, p).

game_loop(GameState, p-c, p) :-
    nl, choose_move(GameState, p, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, p-c, c).

game_loop(GameState, p-c, c) :-
    nl, choose_move(GameState, c, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, p-c, p).

game_loop(GameState, c-c, _) :-
    nl, choose_move(GameState, c, Move),
    move(GameState, Move, NewGameState),
    display_game(NewGameState),
    game_loop(NewGameState, c-c, c).

game_loop(GameState, GameType, Player) :-
    nl, write('Invalid move, try again'), nl,
    game_loop(GameState, GameType, Player).

/**
 * choose_move/3
 * choose_move(+GameState, +Player, -Move)
 *
 * Reads a move from the user or generates a random move for the computer
 */
choose_move((_, _, Size), p, (Row, Column)-(MoveRow, MoveColumn)) :-
    write('Choose a checker to move'), nl,
    read_row(Row, Size),
    read_column(Column, Size),
    nl, write('Choose a place to move'), nl,
    read_row(MoveRow, Size),
    read_column(MoveColumn, Size).

choose_move(GameState, c, Move) :-
    valid_moves(GameState, Moves),
    random_member(Move, Moves),
    format('Computer chose: ~w', [Move]), nl,
    write('Press 1 to continue: '),
    read_number_between(1, 1, _).
