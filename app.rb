load './app/models/player.rb'
load './app/models/card.rb'
load './app/models/piece.rb'
load './app/models/curve_piece.rb'
load './app/models/straight_piece.rb'
load './app/models/crossing_piece.rb'
load './app/models/field.rb'

field = Field.new(2)

# ======

player = :green
card = field.players[player][:cards].last

pp
pp '--- board'
field.render
pp '---'
pp "Piece in play: #{field.piece_in_play}"
pp "Player '#{player}' has target '#{card.image}', the #{card.name}"

#input
pp "Where to push and how to insert piece? (i.e.: 'ec ns')"
push_input = gets.strip
field.push_at(*push_input.split)
pp "Player '#{player}' pushed at '#{field.last_push_at}'"
pp '--- board'
field.render
pp '---'

#input
pp "Where to go? (i.e.: 'sswssee')"
move_input = gets.strip
field.move(player, move_input) 
pp "Player '#{player}' tried to move this path: #{field.players[player][:last_move].join(', ')}"
pp '==='


# ======

player = :blue
card = field.players[player][:cards].last

pp
pp '--- board'
field.render
pp '---'
pp "Piece in play: #{field.piece_in_play}"
pp "Player '#{player}' has target '#{card.image}', the #{card.name}"

#input
pp "Where to push and how to insert piece? (i.e.: 'ec ns')"
push_input = gets.strip
field.push_at(*push_input.split)
pp "Player '#{player}' pushed at '#{field.last_push_at}'"
pp '--- board'
field.render
pp '---'

#input
pp "Where to go? (i.e.: 'sswssee')"
move_input = gets.strip
field.move(player, move_input) 
pp "Player '#{player}' tried to move #{field.players[player][:last_move].join(', ')}"
pp '==='

# ======

pp
pp '--- board'
field.render
pp '---'
pp "Piece in play: #{field.piece_in_play}"
