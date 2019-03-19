# frozen_string_literal: true

class Game

  MAX_INDEX = 6
  MAX_SIZE = 7
  OPPOSITE_DIRECTIONS = {
    north: :south,
    east: :west,
    south: :north,
    west: :east
  }
  PLAYERS = {
    blue: Player.new(:blue, "\u2588\u2588".blue),
    green: Player.new(:green, "\u2588\u2588".green),
    red: Player.new(:red, "\u2588\u2588".red),
    yellow: Player.new(:yellow, "\u2588\u2588".yellow)
  }
  START_CARDS = {
    blue: Card.new(:blue, 'bl'.blue),
    green: Card.new(:green, 'gr'.green),
    red: Card.new(:red, 're'.red),
    yellow: Card.new(:yellow, 'ye'.yellow)
  }
  CARDS = {
    helmet: Card.new(:helmet, 'he'),
    candelabra: Card.new(:candelabra, 'ca'),
    sword: Card.new(:sword, 'sw'),
    emerald: Card.new(:emerald, 'em'),
    treasure: Card.new(:treasure_chest, 'tc'),
    ring: Card.new(:ring, 'ri'),
    skull: Card.new(:skull, 'sk'),
    keys: Card.new(:keys, 'kk'),
    crown: Card.new(:crown, 'cr'),
    map: Card.new(:map, 'ma'),
    money_bag: Card.new(:money_bag, 'mb'),
    book: Card.new(:book, 'bo'),
    mouse: Card.new(:mouse, 'ms'),
    salamander: Card.new(:salamander, 'sa'),
    spider: Card.new(:spider, 'sp'),
    scarab: Card.new(:scarab, 'sc'),
    moth: Card.new(:moth, 'mt'),
    owl: Card.new(:owl, 'ow'),
    bat: Card.new(:bat, 'ba'),
    dragon: Card.new(:dragon, 'dr'),
    witch: Card.new(:witch, 'wi'),
    gini: Card.new(:gini, 'gi'),
    ghost: Card.new(:ghost, 'gh'),
    leprechaun: Card.new(:leprechaun, 'le')
  }
  FIXED_PIECES = {
    blue: CurvePiece.new(%i(east south), START_CARDS[:blue]),
    green: CurvePiece.new(%i(south west), START_CARDS[:green]),
    red: CurvePiece.new(%i(north west), START_CARDS[:red]),
    yellow: CurvePiece.new(%i(east north), START_CARDS[:yellow]),
    helmet: CrossingPiece.new(%i(east south west), CARDS[:helmet]),
    candelabra: CrossingPiece.new(%i(east south west), CARDS[:candelabra]),
    sword: CrossingPiece.new(%i(east north south), CARDS[:sword]),
    emerald: CrossingPiece.new(%i(east north south), CARDS[:emerald]),
    treasure: CrossingPiece.new(%i(east south west), CARDS[:treasure]),
    ring: CrossingPiece.new(%i(north south west), CARDS[:ring]),
    skull: CrossingPiece.new(%i(east north south), CARDS[:skull]),
    keys: CrossingPiece.new(%i(east north west), CARDS[:keys]),
    crown: CrossingPiece.new(%i(north south west), CARDS[:crown]),
    map: CrossingPiece.new(%i(north south west), CARDS[:map]),
    money_bag: CrossingPiece.new(%i(east north west), CARDS[:money_bag]),
    book: CrossingPiece.new(%i(east north west), CARDS[:book])
  }
  STRAIGHT_PIECES = (1..13).map { StraightPiece.new }
  CURVE_PIECES = (1..9).map { CurvePiece.new }
  SYMBOL_CURVE_PIECES = %i(mouse salamander spider scarab moth owl).map { |target| CurvePiece.new(nil, CARDS[target]) }
  SYMBOL_CROSSING_PIECES = %i(bat dragon witch gini ghost leprechaun).map { |target| CrossingPiece.new(nil, CARDS[target]) }
  FREE_PIECES = STRAIGHT_PIECES + CURVE_PIECES + SYMBOL_CURVE_PIECES + SYMBOL_CROSSING_PIECES

  EMPTY_BOARD = [
    [FIXED_PIECES[:blue], nil, FIXED_PIECES[:helmet], nil, FIXED_PIECES[:candelabra], nil, FIXED_PIECES[:green]],
    [nil, nil, nil, nil, nil, nil, nil],
    [FIXED_PIECES[:sword], nil, FIXED_PIECES[:emerald], nil, FIXED_PIECES[:treasure], nil, FIXED_PIECES[:ring]],
    [nil, nil, nil, nil, nil, nil, nil],
    [FIXED_PIECES[:skull], nil, FIXED_PIECES[:keys], nil, FIXED_PIECES[:crown], nil, FIXED_PIECES[:map]],
    [nil, nil, nil, nil, nil, nil, nil],
    [FIXED_PIECES[:yellow], nil, FIXED_PIECES[:money_bag], nil, FIXED_PIECES[:book], nil, FIXED_PIECES[:red]]
  ]
  PUSH_SLOTS = {
    %i(north left) => { x: 1, y: 0 },
    %i(north center) => { x: 3, y: 0 },
    %i(north right) => { x: 5, y: 0 },
    %i(east top) => { x: 6, y: 1 },
    %i(east center) => { x: 6, y: 3 },
    %i(east bottom) => { x: 6, y: 5 },
    %i(south left) => { x: 1, y: 6 },
    %i(south center) => { x: 3, y: 6 },
    %i(south right) => { x: 5, y: 6 },
    %i(west top) => { x: 0, y: 1 },
    %i(west center) => { x: 0, y: 3 },
    %i(west bottom) => { x: 0, y: 5 }
  }

  attr_reader :board, :piece_in_play, :players, :current_player_name, :last_push, :round, :winner

  def initialize(player_count)
    raise 'Number of players is not between 1 and 4.' if player_count < 1 || player_count > 4
    cards_per_player = CARDS.size / player_count
    cards_stack = CARDS.values.shuffle
    (@players = PLAYERS.first(player_count).to_h).each do |_color, player|
      player.enter_game!(cards_stack.shift(cards_per_player))
    end
    @players_order = @players.keys
    @current_player_name = @players_order[0]
    @winner = nil
    @round = 0

    pieces_stack = FREE_PIECES.shuffle
    @board = EMPTY_BOARD.map do |row|
      row.map { |piece| piece.nil? ? pieces_stack.shift : piece }
    end
    @piece_in_play = pieces_stack.shift
    @last_push = nil
  end

  def next_player!
    @round += 1
    @current_player_name = @players_order[@round % @players.size]
  end

  def current_player
    @players[@current_player_name]
  end

  def move_player!(path)
    current_player.last_move = path
    path.each do |direction|
      current_piece = current_player.piece
      x, y = locate_piece(current_piece)
      neighbor_x, neighbor_y = neighbor_coords(x, y, direction) 
      raise "Player tried to leave the board!" if neighbor_y < 0 || neighbor_x < 0 || neighbor_x > 6 || neighbor_y > 6
      neighbor_piece = @board[neighbor_y][neighbor_x]
      raise "There is a wall in the way!" unless current_piece.passages.include?(direction) && neighbor_piece.passages.include?(OPPOSITE_DIRECTIONS[direction])
      current_piece.remove_player(current_player)
      neighbor_piece.add_player(current_player)
      current_player.piece = neighbor_piece
    end
    if current_player.reached_current_card?
      puts "SUCCESS! Player '#{@current_player_name}' conquered the '#{current_player.current_card.name}'."
      current_player.complete_card!
      @winner = @current_player_name if current_player.won?
    end
  rescue StandardError => e
    puts "Move could not finish! #{e.message}"
  end

  def push_at!(slot, passages)
    direction, position = *slot
    push = PUSH_SLOTS[slot]
    raise "Cannot push there." if push.nil?
    raise "Cannot reverse push from last round." if [OPPOSITE_DIRECTIONS[direction], position] == @last_push

    passages.nil? ? @piece_in_play.random_passages! : @piece_in_play.passages = passages
    opposite_piece = @piece_in_play
    @piece_in_play =
      case direction.to_sym
      when :north then push_down(push[:x])
      when :east then push_left(push[:y])
      when :south then push_up(push[:x])
      when :west then push_right(push[:y])
      end

    @piece_in_play.players.each do |player|
      @piece_in_play.remove_player(player)
      opposite_piece.add_player(player)
    end
    @last_push = slot
  end

  private

  def locate_piece(piece)
    x, y = nil, nil
    y = @board.index do |row|
      x = row.index { |row_piece| row_piece == piece }
      !x.nil?
    end
    return x, y
  end

  def neighbor_coords(x, y, direction)
    neighbor_x = x
    neighbor_y = y
    case direction
    when :north then neighbor_y = y - 1
    when :east then neighbor_x = x + 1
    when :south then neighbor_y = y + 1
    when :west then neighbor_x = x - 1
    end
    return neighbor_x, neighbor_y
  end

  def push_down(x)
    moving_piece = @piece_in_play
    replacing_piece = nil
    MAX_SIZE.times do |i|
      replacing_piece = moving_piece
      moving_piece = @board[i][x]
      @board[i][x] = replacing_piece
    end
    moving_piece
  end

  def push_left(y)
    @board[y].push(@piece_in_play)
    @board[y].shift
  end

  def push_up(x)
    moving_piece = @piece_in_play
    replacing_piece = nil
    MAX_SIZE.times do |i|
      reverse_i = MAX_INDEX - i
      replacing_piece = moving_piece
      moving_piece = @board[reverse_i][x]
      @board[reverse_i][x] = replacing_piece
    end
    moving_piece
  end

  def push_right(y)
    @board[y].unshift(@piece_in_play)
    @board[y].pop
  end
end
