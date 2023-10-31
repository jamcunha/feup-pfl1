% r -> Red, b -> Blue, e -> Empty

/**
 * initial_board/1
 * initial_board(-Board)
 *
 * Board is the initial board
 */
initial_board(Board) :-
    Board = [
        [r, b, r, b],
        [b, r, b, r],
        [r, b, r, b],
        [b, r, b, r]
    ].
