require_relative './figure'
require_relative './rook'
class King < Figure
  def available_moves(board)
    moves = standard_moves(board)
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
        next unless move_not_check_mate?(board, x_move, y_move)
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

  def move_not_check_mate?(board, next_x, next_y)
    fields = board.fields
    # to consider: use only enemy figures
    fields.flatten.each do |field|
      figure = field.occupying

      # we skip nil fields & same direction fields as it doesn't bother us
      next if figure.nil? || figure.direction == direction

      enemy_figure_available_moves = figure.available_moves(board)
      return false if enemy_figure_available_moves.include?([next_x, next_y]) # results in check_mate, ignore
    end
    true
  end

  def qualified_for_check_castle_left?(board)
    left_max = board[y][0].occupying

    left_is_rook = left_max.is_a? Rook
    # left_max.

    moves_count == 0 && left_is_rook && left_max.moves_count == 0
    # if ()
  end

  def check_left_castle_path
    # needs to check if path to rook is clear and any field DO NOT result in check
  end

  def castle_moves
  end
end
