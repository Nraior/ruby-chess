require_relative './figure'
require_relative './rook'
class King < Figure
  def available_moves(board)
    standard_moves = standard_moves(board)
    castling_moves = castling_moves(board)
    standard_moves.concat(castling_moves)
  end

  def is_checked?(board)
  end

  private

  def standard_moves(board)
    moves = []
    (-1..1).each do |y_adder|
      (-1..1).each do |x_adder|
        x_move = x + x_adder
        y_move = y + y_adder
        next unless board.valid_move?(x_move, y_move)
        next if is_self?(board, x_move, y_move)

        moves.push([x_move, y_move])
      end
    end
    moves
  end

  def is_self?(board, next_x, next_y)
    field = board.fields[next_y][next_x]
    field.occupying == self
  end

  def castling_moves(board)
    [castle_left_move(board), castle_right_move(board)]
  end

  def castle_left_move(board)
    left_max = board.figure_at_position(0, y)

    return [] unless  moves_count.zero? && left_max.is_a?(Rook) && left_max.moves_count.zero?

    # loop to max left
    (x - 1).downto(1) do |left_x|
      return [] if board.any_team_figures_aims_at_pos?(left_x, y, -direction)
    end

    # it's good, return castle move
    [x - 2, y]
  end

  def castle_right_move(board)
    right_max = board.figure_at_position(board.width - 1, y)

    return [] unless moves_count.zero? && right_max.is_a?(Rook) && right_max.moves_count.zero?

    # loop to max left
    (x - 1).upto(board.width - 1) do |right_x|
      return [] if board.any_team_figures_aims_at_pos?(right_x, y, -direction)
    end

    # it's good, return castle move
    [x + 2, y]
  end
end
