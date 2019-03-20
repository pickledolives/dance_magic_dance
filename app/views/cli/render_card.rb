# frozen_string_literal: true

module RenderCard

  def self.call(card)
    puts '-' * 8
    puts "|      |"
    puts "|      |"
    puts "|  #{card.image}  |"
    puts "|      |"
    puts "|      |"
    puts '-' * 8
  end
end
