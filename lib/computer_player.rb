class ComputerPlayer

  attr_reader :name, :color

  def initialize(name,color)
    @name = name
    @color = color
  end

  def prompt(board)
    return [[6,0],[5,0]]
  end

end
