% TODO: change consult to main file after
:- consult('utils.pl').

/**
 * menu_title/1
 * menu_title(+Title)
 *
 * Prints a title for a menu
 */
menu_title(Title) :-
    string_length(Title, Length),
    Length =< 46, !,
    format('* ~t~w~t~48| *', [Title]).

/**
 * menu_opt/1
 * menu_opt(+Opt)
 *
 * Prints an option for a menu
 */
menu_opt(Opt) :-
    string_length(Opt, Length),
    Length =< 46, !,
    format('* ~w~t~48| *', [Opt]).

/**
 * menu_spacer/0
 *
 * Prints a spacer for a menu
 */
menu_spacer :-
    write('*                                                *').

/**
 * menu_border/0
 *
 * Prints a top/bottom border for a menu
 */
menu_border :-
    write('**************************************************').

/**
 * main_menu/0
 *
 * Prints the main menu
 */
main_menu :-
    repeat,
    clear,
    menu_border, nl,
    menu_title('Main Menu'), nl,
    menu_spacer, nl,
    menu_opt('1. Start Game'), nl,
    menu_opt('2. How to Play'), nl,
    menu_opt('3. Exit'), nl,
    menu_border, nl,
    write('Choose : '),
    read_number_between(1, 3, Opt),
    switch_menu(Opt).

/**
 * switch_menu/1
 * switch_menu(+Opt)
 *
 * Switches the menu based on the option
 */
switch_menu(1) :- starting_game, !.
switch_menu(2) :- instructions_menu, !.
switch_menu(3) :- exit_game, !.

/**
 * instructions_menu/0
 *
 * Prints the instructions menu
 */
instructions_menu :-
    repeat,
    clear,
    menu_border, nl,
    menu_title('How to Play'), nl,
    menu_spacer, nl,
    menu_opt('This is where we will write game instructions'), nl,
    menu_opt('Needs to be edited later'), nl,
    menu_opt('Each line can only have 46 chars'), nl,
    menu_spacer, nl,
    menu_opt('1. Back'), nl,
    menu_border, nl,
    write('Choose : '),
    read_number_between(1, 1, _).

/**
 * starting_game/0
 *
 * Starts the game
 */
starting_game :-
    write('Placeholder for starting game'), nl.

/**
 * exit_game/0
 *
 * Exits the game
 */
exit_game :-
    write('Placeholder for exiting game'), nl.
