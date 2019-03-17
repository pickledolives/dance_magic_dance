class Player
  attr_reader :name, :image, :x, :y

  def initialize(name, image, x, y)
    @name = name
    @image = image
    @x = x
    @y = y
  end
end
