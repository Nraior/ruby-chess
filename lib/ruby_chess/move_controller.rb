require_relative './figures/king'
require_relative './figures/pawn'

class MoveController
  def handle_move(board, figure, move)
    if is_castle_move?(figure, board, move)
      make_castle_move(board, figure, move)
    elsif en_passant_move?(board, figure, move)
      make_en_passant_move(board, figure, move)
    else
      make_standard_move(board, figure, move)
    end
  end

  def make_standard_move(board, figure, move)
    board.update_inside_field_element(figure.x, figure.y, nil)
    board.update_inside_field_element(move[0], move[1], figure)
    figure.proceed_move(move[0], move[1])
  end

  def is_castle_move?(figure, board, move)
    return false unless figure.is_a? King

    figure.castling_moves(board).include?(move)
  end

  def en_passant_move?(board, figure, move)
    return false unless figure.is_a? Pawn

    en_passant = figure.en_passant_moves(board)
    en_passant.include?(move) && board.figure_at_position(move[0], move[1]).nil? # we can't kill 2 figures with en passant move
  end

  def make_en_passant_move(board, figure, move)
    # move to new pos
    make_standard_move(board, figure, move)
    # kill pos below  pawn :-)
    board.update_inside_field_element(figure.x, figure.y - figure.direction, nil)
  end

  def make_castle_move(board, king, move)
    # evaluate direction
    is_left = (king.x - move[0]) > 0

    # move castle
    if is_left
      left_rook = board.figure_at_position(0, king.y)
      make_standard_move(board, left_rook, [move[0] + 1, move[1]])
    else
      right_rook = board.figure_at_position(board.width - 1, king.y)
      make_standard_move(board, right_rook, [move[0] - 1, move[1]])
    end

    # move king
    make_standard_move(board, king, move)
  end
end
