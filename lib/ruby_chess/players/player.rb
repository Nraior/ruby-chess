class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def input
    gets.chomp
  end
end
