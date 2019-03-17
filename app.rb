load './app/models/player.rb'
load './app/models/card.rb'
load './app/models/piece.rb'
load './app/models/curve_piece.rb'
load './app/models/straight_piece.rb'
load './app/models/crossing_piece.rb'
load './app/models/field.rb'

field = Field.new(2)

pp '--- players and cards'
pp field.players

player = :green
card = field.players[player][:cards].last

pp '--- board'
field.render
pp '---'
pp "Player: '#{player}' with target '#{card.image}', the #{card.name}"
pp "Piece in play: #{field.piece_in_play}"
field.push_at(:east, :center)

player = :blue
card = field.players[player][:cards].last

pp '--- board'
field.render
pp '---'
pp "Player: '#{player}' with target '#{card.image}', the #{card.name}"
pp "Piece in play: #{field.piece_in_play}"

field.push_at(:east, :center)

player = :green
card = field.players[player][:cards].last

pp '--- board'
field.render
pp '---'
pp "Player: '#{player}' with target '#{card.image}', the #{card.name}"
pp "Piece in play: #{field.piece_in_play}"
