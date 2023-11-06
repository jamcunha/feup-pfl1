:- consult('board.pl').
:- consult('game.pl').
:- consult('menu.pl').
:- consult('utils.pl').

/**
 * play/0
 *
 * Starts the game.
 */
play :-
    main_menu.
