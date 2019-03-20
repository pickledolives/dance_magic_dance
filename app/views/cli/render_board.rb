# frozen_string_literal: true

module RenderBoard

  SLOT_LABELS = { 1 => 't', 3 => 'c', 5 => 'b' }
  ROWS_PER_TILE = 3

  def self.call(board)
    puts "     \u25B5 #{"n \u25B5 " * 12}"
    puts "     #{' ' * 10}l#{' ' * 13}c#{' ' * 13}r"
    puts "     #{' ' * 8}#{"\u25BC" * 6}#{' ' * 8}#{"\u25BC" * 6}#{' ' * 8}#{"\u25BC" * 6}#{' ' * 8}"
    puts "\u25C3    #{'-' * 50}    \u25B9"
    board.each.with_index do |row_of_pieces, i|
      pushable = i % 2 == 1
      row_of_tiles = row_of_pieces.map { |piece| MakePieceTile.call(piece) }
      ROWS_PER_TILE.times do |i_of_tiles_row|
        even_row = ((i * 4) + i_of_tiles_row) % 2 == 0
        slot_label = pushable && i_of_tiles_row == 1 ? SLOT_LABELS[i] : ' '
        prefix = "#{even_row ? 'w' : "\u25C3"}  #{slot_label}#{pushable ? "\u25B6" : ' '}|"
        suffix = "#{pushable ? "\u25C0" : ' '}#{slot_label}  #{even_row ? 'e' : "\u25B9"}"
        puts prefix + row_of_tiles.map { |tile| tile[i_of_tiles_row] + ['|'] }.join + suffix
      end
      puts "\u25C3    #{'-' * 50}    \u25B9"
    end
    puts "     #{' ' * 8}#{"\u25B2" * 6}#{' ' * 8}#{"\u25B2" * 6}#{' ' * 8}#{"\u25B2" * 6}#{' ' * 8}"
    puts "     #{' ' * 10}l#{' ' * 13}c#{' ' * 13}r"
    puts "     \u25BF #{"s \u25BF " * 12}"
  end
end
