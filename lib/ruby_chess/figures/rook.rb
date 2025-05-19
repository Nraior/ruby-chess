require_relative './figure'
require_relative '../modules/direction_check_move'

class Rook < Figure
  include DirectionCheckMove

  def available_moves(board)
    cross_move(board)
  end
end
