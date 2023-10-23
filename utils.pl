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

read_number(X) :-
    read_number(X, 0).

read_number_between(Min, Max, X) :-
    read_number(X), !,
    X >= Min,
    X =< Max.

clear :- write("\033[2J\033[1;1H").
