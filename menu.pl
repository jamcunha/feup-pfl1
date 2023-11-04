/**
 * menu_title/1
 * menu_title(+Title)
 *
 * Prints a title for a menu
 */
menu_title(Title) :-
    atom_length(Title, Length),
    Length =< 46, !,
    format('* ~t~w~t~48| *', [Title]).

/**
 * menu_opt/1
 * menu_opt(+Opt)
 *
 * Prints an option for a menu
 */
menu_opt(Opt) :-
    atom_length(Opt, Length),
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
    switch_menu(Opt), !.

/**
 * switch_menu/1
 * switch_menu(+Opt)
 *
 * Switches the menu based on the option
 */
switch_menu(1) :- start_game.
switch_menu(2) :- instructions_menu.
switch_menu(3) :- exit_game.

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
    menu_opt('-Red starts the game;'), nl,
    menu_spacer, nl,
    menu_opt('-You can move 1 of your own checkers per turn;'), nl,
    menu_spacer, nl,
    menu_opt('-Passing is not allowed but can be skipped'), nl,
    menu_opt(' if you dont have an available move;'), nl,
    menu_spacer, nl,
    menu_opt('-Can only capture up, down, left or right;'), nl,
    menu_spacer, nl,
    menu_opt('-Can capture a friendly checker'), nl,
    menu_opt(' or an enemy checker;'), nl, 
    menu_spacer, nl,
    menu_opt('-All groups are comprised of checkers'), nl,
    menu_opt(' interconnected horizontally or vertically'), nl,
    menu_opt(' or both;'), nl,
    menu_spacer, nl,
    menu_opt('-Diagonal adjacencies are irrelevant;'), nl, 
    menu_spacer, nl,
    menu_opt('-At the conclusion of your turn'), nl,
    menu_opt(' there should only be one group on the board;'), nl,
    menu_spacer, nl,
    menu_opt('-You can only make a move such that'), nl,
    menu_opt(' after your move there will only be one group'), nl,
    menu_opt(' containing your checkers, which group'), nl,
    menu_opt(' may also contain enemy checkers;'), nl,
    menu_spacer, nl,
    menu_opt('-If your move detaches groups comprised'), nl,
    menu_opt(' only of enemy checkers, immediately '), nl,
    menu_opt(' remove those groups from the board,'), nl,
    menu_opt(' concluding your turn;'), nl,
    menu_spacer, nl,
    menu_opt('1. Back'), nl,
    menu_border, nl,
    write('Choose : '),
    read_number_between(1, 1, _), !,
    main_menu.

/**
 * exit_game/0
 *
 * Exits the game
 */
exit_game :-
    write('Placeholder for exiting game'), nl.
