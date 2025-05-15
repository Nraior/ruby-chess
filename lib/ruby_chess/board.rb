require_relative 'field'
require_relative './figures/king'

class Board
  attr_reader :fields, :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @fields = []
  end

  def create
    @fields = Array.new(@height) do |y|
      Array.new(@width) do |x|
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

  def update_inside_field_element(x, y, figure = nil)
    fields[y][x].occupy(figure)
  end
end
