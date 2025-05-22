require_relative 'figure'
require_relative '../modules/direction_check_move'
class Bishop < Figure
  include DirectionCheckMove

  def available_moves(board)
    diagonal_moves(board)
  end

  def symbol_pool
    ['♗', '♝']
  end
end
