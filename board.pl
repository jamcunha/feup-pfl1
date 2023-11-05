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
 * initial_board/2
 * initial_board(+N, -Board)
 *
 * Predicate to create an NxN board with alternating red and blue pieces.
 */
initial_board(N, Board) :-
    initial_board(N, N, Board).

initial_board(0, _, []).
initial_board(N, NCols, [Row|Rest]) :-
    create_row(NCols, N, Row),
    N1 is N - 1,
    initial_board(N1, NCols, Rest).


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
 * is_orthogonal/4
 * is_orthogonal(+Row1, +Column1, +Row2, +Column2)
 *
 * Predicate that checks if two checkers are orthogonal
 */
is_orthogonal(R1, C, R2, C) :- R2 is R1 + 1.
is_orthogonal(R1, C, R2, C) :- R2 is R1 - 1.
is_orthogonal(R, C1, R, C2) :- C2 is C1 + 1.
is_orthogonal(R, C1, R, C2) :- C2 is C1 - 1.

/**
 * display_board/2
 * display_board(+Board, +Size)
 *
 * Predicate that displays the board
 */
display_board(Board, Size) :-
    display_board_header(Size, 0), nl,
    display_board_spacer(Size, 0), nl,
    display_board(Board, Size, 0).

/**
 * display_board_spacer/2
 * display_board_spacer(+N, +Acc)
 *
 * Displays the board spacer
 * N is the board size (N x N)
 */
display_board_spacer(N, N).
display_board_spacer(N, 0) :-
    write('--------'),
    display_board_spacer(N, 1).

display_board_spacer(N, Acc) :-
    Acc < N,
    write('----'),
    Acc1 is Acc + 1,
    display_board_spacer(N, Acc1).

/**
 * display_board_header/2
 * display_board_header(+N, +Acc)
 *
 * Displays the board header
 * N is the board size (N x N)
 */
display_board_header(N, N).
display_board_header(N, 0) :-
    write('   | '),
    write(0),
    write(' |'),
    display_board_header(N, 1).

display_board_header(N, Acc) :-
    Acc < N,
    write(' '),
    write(Acc),
    write(' |'),
    Acc1 is Acc + 1,
    display_board_header(N, Acc1).

/**
 * display_board/2
 * display_board(+Board, +N)
 *
 * Auxiliary predicate to displays the board
 * N is the number of the row
 */
display_board([], _, _).
display_board([Row|Rest], Size, N) :-
    write(' '),
    write(N),
    write(' | '),
    display_row(Row), nl,
    display_board_spacer(Size, 0), nl,
    N1 is N + 1,
    display_board(Rest, Size, N1).

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

/**
 * create_row/3
 * create_row(+NCols, +N, -Row)
 *
 * Auxiliary predicate to create a row of the board
 * NCols is the number of columns
 * N is the size of the board
 */
create_row(0, _, []).
create_row(NCols, N, [Piece|Rest]) :-
    N1 is N - 1,
    N2 is N1 mod 2,
    N2 =:= 0,
    NCols1 is NCols - 1,
    NCols2 is NCols1 mod 2,
    NCols2 =:= 0,
    Piece = red,
    create_row(NCols1, N, Rest).

create_row(NCols, N, [Piece|Rest]) :-
    N1 is N - 1,
    N2 is N1 mod 2,
    N2 =:= 1,
    NCols1 is NCols - 1,
    NCols2 is NCols1 mod 2,
    NCols2 =:= 1,
    Piece = red,
    create_row(NCols1, N, Rest).

create_row(NCols, N, [Piece|Rest]) :-
    N1 is N - 1,
    N2 is N1 mod 2,
    N2 =:= 0,
    NCols1 is NCols - 1,
    NCols2 is NCols1 mod 2,
    NCols2 =:= 1,
    Piece = blue,
    create_row(NCols1, N, Rest).

create_row(NCols, N, [Piece|Rest]) :-
    N1 is N - 1,
    N2 is N1 mod 2,
    N2 =:= 1,
    NCols1 is NCols - 1,
    NCols2 is NCols1 mod 2,
    NCols2 =:= 0,
    Piece = blue,
    create_row(NCols1, N, Rest).
