load './app/models/piece.rb'
load './app/models/curve_piece.rb'
load './app/models/straight_piece.rb'
load './app/models/crossing_piece.rb'
load './app/models/field.rb'

field = Field.new

pp '--- board'
pp field.board.map { |row| row.map(&:to_s) }
pp '---'
pp "Piece in play: #{field.piece_in_play}"

field.push_at(:east, :center)

pp '--- board'
pp field.board.map { |row| row.map(&:to_s) }
pp '---'
pp "Piece in play: #{field.piece_in_play}"

