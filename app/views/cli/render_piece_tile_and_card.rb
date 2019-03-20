# frozen_string_literal: true

module RenderPieceTileAndCard

  MARGIN = 10
  ROWS_PER_TILE = 3

  def self.call(piece, card)
    tile = MakePieceTile.call(piece)
    puts "    n     #{margin}#{'-' * 8}"
    puts " #{'-' * 8} #{margin}|      |"
    ROWS_PER_TILE.times do |i|
      if i == 1
        puts "w|#{tile[i].join}|e#{margin}|  #{card.image}  |"
      else
        puts " |#{tile[i].join}| #{margin}|      |"
      end
    end
    puts " #{'-' * 8} #{margin}|      |"
    puts "    s     #{margin}#{'-' * 8}"
  end

  def self.margin
    ' ' * MARGIN
  end
end
