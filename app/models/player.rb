class Player
  attr_reader :name, :image
  attr_accessor :x, :y

  def initialize(name, image, x, y)
    @name = name
    @image = image
    @x = x
    @y = y
  end
end
