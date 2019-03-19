# frozen_string_literal: true

module RenderPieceTile

  def self.call(piece)
    tile = MakePieceTile.call(piece)
    puts "    n     "
    puts " #{'-' * 8} "
    3.times { |i| puts "#{i == 1 ? 'w' : ' '}|#{tile[i].join}|#{i == 1 ? 'e' : ' '}" }
    puts " #{'-' * 8} "
    puts "    s     "
  end
end
