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
    [castle_left_move(board), castle_right_move(board)].reject(&:empty?)
  end

  private

  def castling_move_to_valid?(board, fig, loop)
    return false unless moves_count.zero? && fig.is_a?(Rook) && fig.moves_count.zero?

    loop.each do |checked_x|
      return false if board.any_team_figures_aims_at_pos?(checked_x, y, -direction)
    end
    true
  end

  def castle_left_move(board)
    fig = board.figure_at_position(0, y)
    loop = x.downto(0)
    return [] unless castling_move_to_valid?(board, fig, loop)

    [x - 2, y]
  end

  def castle_right_move(board)
    fig = board.figure_at_position(board.width - 1, y)

    loop = x.upto(board.width - 1)
    return [] unless castling_move_to_valid?(board, fig, loop)

    # it's good, return castle move
    [x + 2, y]
  end

  def symbol_pool
    ['♔', '♚']
  end
end
