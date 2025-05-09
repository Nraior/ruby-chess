module DirectionCheckMove
  def cross_move(board)
    moves = []

    left_moves = check_direction(board, x, y)
    right_moves = check_direction(board, x, y, [], 1, 0)
    up_moves = check_direction(board, x, y, [], 0, -1)
    down_moves = check_direction(board, x, y, [], 0, 1)

    moves.push(left_moves).push(right_moves).push(up_moves).push(down_moves)

    moves.flatten(1)
  end

  def diagonal_moves(board)
    moves = cross_move

    left_up_moves = check_direction(board, x, y, -1, -1)
    right_up_moves = check_direction(board, x, y, [], 1, -1)
    left_down_moves = check_direction(board, x, y, [], -1, 1)
    left_right_moves = check_direction(board, x, y, [], 1, 1)

    moves.push(left_up_moves).push(right_up_moves).push(left_down_moves).push(left_right_moves)

    moves.flatten(1)
  end

  private

  def check_direction(board, x, y, moves = [], x_direction = -1, y_direction = 0)
    return moves unless board.valid_move?(x + x_direction,
                                          y + y_direction)

    next_figure = board.figure_at_position(x + x_direction, y + y_direction)
    return moves if ally?(next_figure)

    moves.push([x + x_direction, y + y_direction])

    return moves if enemy?(next_figure)

    fields = board.fields
    return moves unless fields[y + y_direction][x + x_direction].occupying.nil?

    check_direction(board, x + x_direction, y + y_direction, moves, x_direction, y_direction)
  end
end
