require_relative './figure'
require_relative '../modules/direction_check_move'
require_relative '../own_checkmate_checker'

class Rook < Figure
  include DirectionCheckMove

  def available_moves(board)
    cross_move(board)
  end

  def legal_moves(board)
    moves = available_moves(board)
    moves.filter do |move|
      !OwnChekmateChecker.will_cause_own_checkmate?(self, board, move[0], move[1])
    end
  end
end
