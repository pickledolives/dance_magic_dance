# frozen_string_literal: true

load './lib/extensions/string.rb'

load './app/models/player.rb'
load './app/models/card.rb'
load './app/models/piece.rb'
load './app/models/curve_piece.rb'
load './app/models/straight_piece.rb'
load './app/models/crossing_piece.rb'
load './app/models/game.rb'
load './app/views/cli/render_piece_tile.rb'
load './app/views/cli/render_board.rb'

QUITS = %w(q quit exit)
DIRECTION_ABBREVS = {
  'n' => :north,
  'e' => :east,
  's' => :south,
  'w' => :west
}
POSITION_ABBREVS = {
  't' => :top,
  'c' => :center,
  'b' => :bottom,
  'l' => :left,
  'r' => :right
}

def retry_input_until_valid
  invalid_input = true
  while(invalid_input)
    begin
      yield
      invalid_input = false
    rescue StandardError => e
      puts e.message
    end
  end
end

def parse_slot(push_abbrev)
  letters = push_abbrev.split('')
  direction = DIRECTION_ABBREVS[letters[0]] || raise('Slot contains an invalid direction letter!')
  position = POSITION_ABBREVS[letters[1]] || raise('Slot contains an invalid position letter!')
  [direction, position]
end

def parse_piece_passages(passages_abbrev)
  passages_abbrev.split('').map do |letter|
    DIRECTION_ABBREVS[letter] || raise('Piece passages contain an invalid direction letter!')
  end
end

def parse_path(path_abbrev)
  path_abbrev.split('').map do |letter|
    DIRECTION_ABBREVS[letter] || raise('Path contains an invalid direction letter!')
  end
end

puts "How may players? (1-4)"
players_input = gets.strip
game = Game.new(players_input.to_i)

while game.winner.nil?
  puts
  puts '--- board'
  RenderBoard.call(game.board)
  puts '---'
  puts "Piece in play: #{game.piece_in_play}"
  puts "Player '#{game.current_player_name}'s current card is #{game.current_player.current_card}"
  retry_input_until_valid do
    puts "Where to push and how to insert piece? (i.e.: 'ec ns')"
    push_input = gets.strip
    exit if QUITS.include?(push_input)
    slot_abbrev, piece_passages_abbrev = push_input.split
    game.push_at!(parse_slot(slot_abbrev), piece_passages_abbrev.nil? ? nil : parse_piece_passages(piece_passages_abbrev))
  end
  puts "Player '#{game.current_player_name}' pushed at '#{game.last_push}'"
  puts '--- board'
  RenderBoard.call(game.board)
  puts '---'

  retry_input_until_valid do
    puts "Where to go? (i.e.: 'sswssee')"
    move_input = gets.strip
    exit if QUITS.include?(move_input)
    game.move_player!(parse_path(move_input))
  end
  puts "Player '#{game.current_player_name}' tried to move #{game.current_player.last_move.join(', ')}"
  puts '==='
  puts
  game.next_player!
end

puts
puts '--- board'
RenderBoard.call(game.board)
puts '---'
puts "VICTORY!!! Player '#{game.winner}' won the game, congratulations!"
