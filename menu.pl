% TODO: change consult to main file after
:- consult('utils.pl').

menu_title(Title) :-
    string_length(Title, Length),
    Length =< 46, !,
    format("* ~t~w~t~48| *", [Title]).

menu_opt(Opt) :-
    string_length(Opt, Length),
    Length =< 46, !,
    format("* ~w~t~48| *", [Opt]).

menu_spacer :-
    write("*                                                *").

menu_border :-
    write("**************************************************").

main_menu :-
    repeat,
    clear,
    menu_border, nl,
    menu_title("Main Menu"), nl,
    menu_spacer, nl,
    menu_opt("1. Start Game"), nl,
    menu_opt("2. How to Play"), nl,
    menu_opt("3. Exit"), nl,
    menu_border, nl,
    write("Choose : "),
    read_number_between(1, 3, Opt),
    write(Opt), nl.
