require_relative 'figure'
class Rook < Figure
  def available_moves(board)
    moves = []

    left_moves = check_direction(board, x, y)
    right_moves = check_direction(board, x, y, [], 1, 0)
    up_moves = check_direction(board, x, y, [], 0, -1)
    down_moves = check_direction(board, x, y, [], 0, 1)

    moves.push(left_moves).push(right_moves).push(up_moves).push(down_moves)

    moves.flatten(1)
  end

  private

  def check_direction(board, x, y, moves = [], x_direction = -1, y_direction = 0)
    return moves if !board.valid_move?(x + x_direction,
                                       y + y_direction) && !board.enemy_at_position?(self, x + x_direction,
                                                                                     y + y_direction)

    moves.push([x + x_direction, y + y_direction])

    check_direction(board, x + x_direction, y + y_direction, moves, x_direction, y_direction)
  end
end
