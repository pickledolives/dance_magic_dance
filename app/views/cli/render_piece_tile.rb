# frozen_string_literal: true

module RenderPieceTile

  ROWS_PER_TILE = 3

  def self.call(piece)
    tile = MakePieceTile.call(piece)
    puts "    n     "
    puts " #{'-' * 8} "
    ROWS_PER_TILE.times { |i| puts "#{i == 1 ? 'w' : ' '}|#{tile[i].join}|#{i == 1 ? 'e' : ' '}" }
    puts " #{'-' * 8} "
    puts "    s     "
  end
end
