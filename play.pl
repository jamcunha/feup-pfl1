:- consult('utils.pl').
:- consult('menu.pl').
:- consult('board.pl').

/**
 * play/0
 *
 * Starts the game.
 */
play :-
    main_menu.
