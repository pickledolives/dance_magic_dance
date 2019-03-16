load './app/models/field.rb'

field = Field.new

pp '--- board'
pp field.board
pp '---'
pp "Piece in play: #{field.piece_in_play}"

field.push_at(:east, :center)

field.push_at(:west, :center)

pp '--- board'
pp field.board
pp '---'
pp "Piece in play: #{field.piece_in_play}"

