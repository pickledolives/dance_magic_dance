# frozen_string_literal: true

class Card
  attr_reader :name, :image

  def initialize(name, image)
    @name = name
    @image = image
  end

  def to_s
    "'#{image}', the #{name}"
  end
end
