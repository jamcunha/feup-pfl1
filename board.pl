% Board representation
%
%    | 0 | 1 | 2 | 3 |
% --------------------
%  0 | R | B | R | B |
% --------------------
%  1 | B | R | B | R |
% --------------------
%  2 | R | B | R | B |
% --------------------
%  3 | B | R | B | R |
% --------------------

/**
 * initial_board/1
 * initial_board(-Board)
 *
 * Board is the initial board
 */
initial_board(Board) :-
    Board = [
        [red, blue, red, blue],
        [blue, red, blue, red],
        [red, blue, red, blue],
        [blue, red, blue, red]
    ].

/**
 * symbol/2
 * symbol(+Piece, -Symbol)
 *
 * Predicate that associates symbols ready to be printed to board
 */
symbol(red, 'R').
symbol(blue, 'B').
symbol(empty, ' ').

/**
 * display_board/1
 * display_board(+Board)
 *
 * Predicate that displays the board
 */
display_board(Board) :-
    write('   | 0 | 1 | 2 | 3 |\n'),
    write('--------------------\n'),
    display_board(Board, 0).

/**
 * display_board/2
 * display_board(+Board, +N)
 *
 * Auxiliary predicate to displays the board
 * N is the number of the row
 */
display_board([], _).
display_board([Row|Rest], N) :-
    write(' '),
    write(N),
    write(' | '),
    display_row(Row),
    write('\n'),
    write('--------------------\n'),
    N1 is N + 1,
    display_board(Rest, N1).

/**
 * display_row/1
 * display_row(+Row)
 *
 * Auxiliary predicate to displays a row of the board
 */
display_row([]).
display_row([Piece|Rest]) :-
    symbol(Piece, Symbol),
    write(Symbol),
    write(' | '),
    display_row(Rest).
