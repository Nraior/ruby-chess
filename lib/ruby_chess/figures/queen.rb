require_relative '../modules/direction_check_move'
require_relative './figure'
class Queen < Figure
  include DirectionCheckMove

  def available_moves(board)
    cross_move(board).concat(diagonal_moves(board))
  end

  private

  def symbol_pool
    ['♕', '♛']
  end
end
