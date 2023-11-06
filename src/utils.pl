:- use_module(library(lists)).

/**
 * read_number/2
 * read_number(-X, +Acc)
 *
 * Auxiliary predicate for read_number/1.
 */
read_number(X, X) :-
    peek_code(10), !,
    skip_line.

read_number(X, Acc) :-
    get_code(Code),
    Code \= 10,
    char_code('0', Zero),
    N is Code - Zero,
    N >= 0,
    N =< 9,
    Acc1 is Acc * 10 + N,
    read_number(X, Acc1).

/**
 * read_number/1
 * read_number(-X)
 *
 * Reads a number from the input stream.
 * The number is read until a non-digit character is found.
 * The number is returned in X.
 */
read_number(X) :-
    read_number(X, 0).

/**
 * read_number_between/3
 * read_number_between(+Min, +Max, -X)
 *
 * Reads a number that is between Min and Max.
 */
read_number_between(Min, Max, X) :-
    read_number(X), !,
    X >= Min,
    X =< Max.

/**
 * clear/0
 *
 * Clears the screen.
 */
clear :- write('\e[H\e[2J').

/**
 * list_get/3
 * list_get(+List, +Index, -Value)
 *
 * Gets the element at Index in List.
 */
list_get(List, Index, Value) :-
    nth0(Index, List, Value).

/**
 * matrix_get/4
 * matrix_get(+Matrix, +Row, +Col, -Value)
 *
 * Gets the element at (Row, Col) in Matrix.
 */
matrix_get(Matrix, Row, Col, Value) :-
    nth0(Row, Matrix, RowList),
    nth0(Col, RowList, Value).

/**
 * list_replace/4
 * list_replace(+List, +Index, +Value, -Result)
 *
 * Replaces the element at Index in List with Value.
 */
list_replace(List, Index, Value, Result) :-
    nth0(Index, List, _, Temp),
    nth0(Index, Result, Value, Temp).

/**
 * matrix_replace/5
 * matrix_replace(+Matrix, +Row, +Col, +Value, -Result)
 *
 * Replaces the element at (Row, Col) in Matrix with Value.
 */
matrix_replace([H|T], Row, Col, Value, [H|TR]) :-
    Row > 0,
    Row1 is Row - 1, !,
    matrix_replace(T, Row1, Col, Value, TR).

matrix_replace([H|T], 0, Col, Value, [HR|T]) :-
    list_replace(H, Col, Value, HR), !.

/**
 * matrix_member/2
 * matrix_member(+Matrix, +Value)
 *
 * Checks if Value is a member of Matrix.
 */
matrix_member(Matrix, Value) :-
    member(Row, Matrix),
    member(Value, Row).
