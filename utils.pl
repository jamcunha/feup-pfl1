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
clear :- write('\033[2J\033[1;1H').
