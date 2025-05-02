require_relative 'figure'
class Pawn < Figure
  def available_moves(board)
    moves = []
    fields = board.fields

    (1..2).each do |n|
      x_pos = @x
      # p n
      y_pos = @y + (@direction * n)
      next unless board.valid_move?(y_pos, x_pos)

      p y_pos
      p fields[y + (@direction * n)][@x].occupying.nil?

      moves.push([y_pos, x_pos]) if fields[y + (@direction * n)][@x].occupying.nil?
      # p board[y + (@direction * 1)][@x].occupying
    end
    moves
  end
end
