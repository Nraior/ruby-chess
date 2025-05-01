class Field
  attr_reader :occupying

  def initialize(pos_x, pos_y)
    @x = pos_x
    @y = pos_y
    @occupying = nil
  end

  def occupy(figure)
    @occupying = figure
  end

  def free
    @occupying = nil
  end
end
