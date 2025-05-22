require_relative 'field'
require_relative './figures/king'
require_relative './figures/bishop'
require_relative './figures/horse'
require_relative './figures/rook'
require_relative './figures/pawn'
require_relative './figures/queen'

class Board
  attr_reader :fields

  def initialize(w, h)
    @fields = []

    create(w, h)
  end

  def width(level = 0)
    fields[level].length
  end

  def height
    fields.length
  end

  def display
    fields.each do |field_row|
      row_str = ''
      field_row.each do |field|
        row_str += field.to_s + ' '
      end
      p row_str
    end
  end

  def create(width = 8, height = 8)
    @fields = Array.new(height) do |y|
      Array.new(width) do |x|
        Field.new(x, y)
      end
    end
  end

  def valid_move?(x, y)
    height = fields.length
    width = fields[0].length

    y < height && x < width && x >= 0 && y >= 0
  end

  def figure_at_position(x, y)
    return nil unless valid_move?(x, y)

    field = fields[y][x]
    field&.occupying
  end

  def team_figures(direction)
    figures = []
    fields.flatten.each do |field|
      figures.push(field.occupying) if field.occupying&.direction == direction
    end
    figures
  end

  def team_king(direction)
    fields.flatten.each do |field|
      return field.occupying if field.occupying&.direction == direction && field.occupying.is_a?(King)
    end
    nil
  end

  def any_team_figures_aims_at_pos?(pos_x, pos_y, team_direction)
    figures = team_figures(team_direction)
    figures.any? do |figure|
      figure.available_moves(self).include?([pos_x, pos_y])
    end
  end

  def update_inside_field_element(x, y, figure = nil)
    fields[y][x].occupy(figure)
  end

  def fill_board(up_team_figs, bottom_team_figs)
    # fill pawns
    fields[1].each_with_index do |pawn_field, x|
      pawn_field.occupy(Pawn.new(x, 1, 1))
    end

    fields[0].each_with_index do |field, index|
      field.occupy(up_team_figs[index].new(index, 0, 1))
    end

    # bottom
    fields[height - 2].each_with_index do |pawn_field, x|
      pawn_field.occupy(Pawn.new(x, height - 2))
    end

    fields[height - 1].each_with_index do |field, index|
      field.occupy(bottom_team_figs[index].new(index, height - 1))
    end
  end

  def self.create_chess_board
    created_board = Board.new(8, 8)

    figures = [Rook, Horse, Bishop, Queen, King, Bishop, Horse, Rook]

    created_board.fill_board(figures, figures)

    # white

    # black
    created_board
  end
end
