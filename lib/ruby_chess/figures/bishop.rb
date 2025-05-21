require_relative 'figure'
require_relative '../modules/direction_check_move'
class Bishop < Figure
  include DirectionCheckMove
  def symbol
    direction == 1 ? symbol_pool[0] : symbol_pool[1]
  end

  def available_moves(board)
    diagonal_moves(board)
  end

  def symbol_pool
    ['♗', '♝']
  end
end
