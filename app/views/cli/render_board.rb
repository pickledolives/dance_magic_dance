# frozen_string_literal: true

module RenderBoard

  SLOT_LABELS = { 1 => 't', 3 => 'c', 5 => 'b' }
  Y_SLOTS = { 1 => :top, 3 => :center, 5 => :bottom }
  ROWS_PER_TILE = 3

  def self.call(board, player = nil, push_slot = nil)
    color = player&.name || nil
    trace = player&.last_move_trace || []
    down = "\u25BC" * 6
    north_left = push_slot == %i(north left) ? down.send(color) : down
    north_center = push_slot == %i(north center) ? down.send(color) : down
    north_right = push_slot == %i(north right) ? down.send(color) : down
    up = "\u25B2" * 6
    south_left = push_slot == %i(south left) ? up.send(color) : up
    south_center = push_slot == %i(south center) ? up.send(color) : up
    south_right = push_slot == %i(south right) ? up.send(color) : up
    left = "\u25C0"
    right = "\u25B6"

    puts "     \u25B5 #{"n \u25B5 " * 12}"
    puts "     #{' ' * 10}l#{' ' * 13}c#{' ' * 13}r"
    puts "     #{' ' * 8}#{north_left}#{' ' * 8}#{north_center}#{' ' * 8}#{north_right}#{' ' * 8}"
    puts "\u25C3    #{'-' * 50}    \u25B9"
    board.each.with_index do |row_of_pieces, i|
      pushable = i % 2 == 1
      row_of_tiles = row_of_pieces.map { |piece| MakePieceTile.call(piece, trace.include?(piece) ? color : nil) }
      ROWS_PER_TILE.times do |i_of_tiles_row|
        even_row = ((i * 4) + i_of_tiles_row) % 2 == 0
        slot_label = pushable && i_of_tiles_row == 1 ? SLOT_LABELS[i] : ' '
        west_y = push_slot == [:west, Y_SLOTS[i]] ? right.send(color) : right
        prefix = "#{even_row ? 'w' : "\u25C3"}  #{slot_label}#{pushable ? west_y : ' '}|"
        east_y = push_slot == [:east, Y_SLOTS[i]] ? left.send(color) : left
        suffix = "#{pushable ? east_y : ' '}#{slot_label}  #{even_row ? 'e' : "\u25B9"}"
        puts prefix + row_of_tiles.map { |tile| tile[i_of_tiles_row] + ['|'] }.join + suffix
      end
      puts "\u25C3    #{'-' * 50}    \u25B9"
    end
    puts "     #{' ' * 8}#{south_left}#{' ' * 8}#{south_center}#{' ' * 8}#{south_right}#{' ' * 8}"
    puts "     #{' ' * 10}l#{' ' * 13}c#{' ' * 13}r"
    puts "     \u25BF #{"s \u25BF " * 12}"
  end
end
