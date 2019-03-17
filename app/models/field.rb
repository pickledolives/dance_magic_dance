class Field
  MAX_INDEX = 6
  MAX_SIZE = 7

  OPPOSITE_DIRECTIONS = {
    north: :south,
    east: :west,
    south: :north,
    west: :east
  }
  DIRECTION_ABBREVS = {
    'n' => :north,
    'e' => :east,
    's' => :south,
    'w' => :west
  }
  SLOT_ABBREVS = {
    't' => :top,
    'c' => :center,
    'b' => :bottom,
    'l' => :left,
    'r' => :right
  }

  PLAYERS = {
    blue: Player.new(:blue, 'B', 0, 0),
    green: Player.new(:green, 'G', 6, 0),
    red: Player.new(:red, 'R', 0, 6),
    yellow: Player.new(:yellow, 'Y', 6, 6)
  }
  STARTS = {
    blue: Card.new('blue', 'bl'),
    green: Card.new('green', 'gr'),
    red: Card.new('red', 're'),
    yellow: Card.new('yellow', 'ye')
  }
  CARDS = {
    helmet: Card.new('helmet', 'he'),
    candelabra: Card.new('candelabra', 'ca'),
    sword: Card.new('sword', 'sw'),
    emerald: Card.new('emerald', 'em'),
    treasure: Card.new('treasure chest', 'tc'),
    ring: Card.new('ring', 'ri'),
    skull: Card.new('skull', 'sk'),
    keys: Card.new('keys', 'kk'),
    crown: Card.new('crown', 'cr'),
    map: Card.new('map', 'ma'),
    money_bag: Card.new('money bag', 'mb'),
    book: Card.new('book', 'bo'),
    mouse: Card.new('mouse', 'ms'),
    salamander: Card.new('salamander', 'sa'),
    spider: Card.new('spider', 'sp'),
    scarab: Card.new('scarab', 'sc'),
    moth: Card.new('moth', 'mt'),
    owl: Card.new('owl', 'ow'),
    bat: Card.new('bat', 'ba'),
    dragon: Card.new('dragon', 'dr'),
    witch: Card.new('witch', 'wi'),
    gini: Card.new('gini', 'gi'),
    ghost: Card.new('ghost', 'gh'),
    leprechaun: Card.new('leprechaun', 'le')
  }

  FIXED_PIECES = [
    [CurvePiece.new('se', STARTS[:blue], [PLAYERS[:blue]]), nil, CrossingPiece.new('wse', CARDS[:helmet]), nil, CrossingPiece.new('wse', CARDS[:candelabra]), nil, CurvePiece.new('sw', STARTS[:green], [PLAYERS[:green]])],
    [nil, nil, nil, nil, nil, nil, nil],
    [CrossingPiece.new('nes', CARDS[:sword]), nil, CrossingPiece.new('nes', CARDS[:emerald]), nil, CrossingPiece.new('esw', CARDS[:treasure]), nil, CrossingPiece.new('nsw', CARDS[:ring])],
    [nil, nil, nil, nil, nil, nil, nil],
    [CrossingPiece.new('nes', CARDS[:skull]), nil, CrossingPiece.new('ewn', CARDS[:keys]), nil, CrossingPiece.new('nws', CARDS[:crown]), nil, CrossingPiece.new('nws', CARDS[:map])],
    [nil, nil, nil, nil, nil, nil, nil],
    [CurvePiece.new('ne', STARTS[:yellow], [PLAYERS[:yellow]]), nil, CrossingPiece.new('ewn', CARDS[:money_bag]), nil, CrossingPiece.new('ewn', CARDS[:book]), nil, CurvePiece.new('nw', STARTS[:red], [PLAYERS[:red]])]
  ]

  FREE_PIECES = (1..13).map { StraightPiece.new } + (1..9).map { CurvePiece.new } + [CurvePiece.new(nil, CARDS[:mouse]), CurvePiece.new(nil, CARDS[:salamander]), CurvePiece.new(nil, CARDS[:spider]), CurvePiece.new(nil, CARDS[:scarab]), CurvePiece.new(nil, CARDS[:moth]), CurvePiece.new(nil, CARDS[:owl])] + [CrossingPiece.new(nil, CARDS[:bat]), CrossingPiece.new(nil, CARDS[:dragon]), CrossingPiece.new(nil, CARDS[:witch]), CrossingPiece.new(nil, CARDS[:gini]), CrossingPiece.new(nil, CARDS[:ghost]), CrossingPiece.new(nil, CARDS[:leprechaun])]

  PUSHABLES = {
    north_left: { x: 1, y: 0, opposite_of: :south_left },
    north_center: { x: 3, y: 0, opposite_of: :south_center },
    north_right: { x: 5, y: 0, opposite_of: :south_right },
    east_top: { x: 6, y: 1, opposite_of: :west_top },
    east_center: { x: 6, y: 3, opposite_of: :west_center },
    east_bottom: { x: 6, y: 5, opposite_of: :west_bottom },
    south_left: { x: 1, y: 6, opposite_of: :north_left },
    south_center: { x: 3, y: 6, opposite_of: :north_center },
    south_right: { x: 5, y: 6, opposite_of: :north_right },
    west_top: { x: 0, y: 1, opposite_of: :east_top },
    west_center: { x: 0, y: 3, opposite_of: :east_center },
    west_bottom: { x: 0, y: 5, opposite_of: :east_bottom }
  }

  attr_reader :board, :piece_in_play, :players, :last_push_at

  def initialize(player_count)
    cards_per_player = CARDS.size / player_count
    cards_stack = CARDS.values.shuffle
    player_starts = STARTS.first(player_count).to_h
    @players = player_starts.map do |color, start_card|
      player = PLAYERS[color]
      cards = [start_card] + cards_stack.shift(cards_per_player)
      piece = FIXED_PIECES[player.y][player.x]
      [color, { player: player, cards: cards, piece: piece, completed_cards: [], last_move: nil }]
    end.to_h

    pieces_stack = FREE_PIECES.dup.shuffle
    @board = FIXED_PIECES.map do |row|
      row.map do |piece|
        piece.nil? ? pieces_stack.shift : piece
      end
    end
    @piece_in_play = pieces_stack.shift
    @last_push_at = nil
    raise "there are pieces left!" unless pieces_stack.empty?
  end

  def move(player_name, path)
    player_state = @players[player_name]
    player = player_state[:player]
    path = parse_path(path) if path.is_a?(String)
    player_state[:last_move] = path
    path.each do |direction|
      current_piece = player_state[:piece]
      neighbor_x, neighbor_y = neighbor_coords(player.x, player.y, direction) 
      neighbor_piece = @board[neighbor_y][neighbor_x]
      raise "there is a wall in the way!" unless current_piece.passages.include?(direction) && neighbor_piece.passages.include?(OPPOSITE_DIRECTIONS[direction])
      player.x = neighbor_x
      player.y = neighbor_y
      player_state[:piece] = neighbor_piece
      current_piece.remove_player(player)
      neighbor_piece.add_player(player)
    end
    if player_state[:piece].card == player_state[:cards].last
      player_state[:completed_cards].push(player_state[:cards].pop)
      pp "SUCCESS!!! Player '#{player_name}' conquered the '#{player_state[:completed_cards].last.name}'"
    end
  rescue StandardError => e
    pp "Move could not finish! #{e.message}"
  end

  def push_at(push_abbrev, passages = nil)
    direction, position = parse_push(push_abbrev)
    push_id = "#{direction}_#{position}".to_sym
    push = PUSHABLES[push_id]
    raise "Cannot push there" if push.nil?
    raise "Cannot reverse push from last round" if push[:opposite_of] == @last_push

    passages.nil? ? @piece_in_play.random_passages : @piece_in_play.passages = passages
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
    @last_push_at = push_id
  end

  def render
    puts '-' * 50
    @board.each do |row_of_pieces|
      row_of_tiles = row_of_pieces.map(&:render_tile)
      (0..2).map { |i| puts '|' + row_of_tiles.map { |tile| tile[i] + ['|'] }.join }
      puts '-' * 50
    end
  end

  private

  def neighbor_coords(x, y, direction)
    neighbor_x = x.dup
    neighbor_y = y.dup
    case direction
    when :north then neighbor_y = y - 1
    when :east then neighbor_x = x + 1
    when :south then neighbor_y = y + 1
    when :west then neighbor_x = x - 1
    end
    raise "Move is outside the board" if neighbor_y < 0 || neighbor_x < 0 || neighbor_x > 6 || neighbor_y > 6 
    return neighbor_x, neighbor_y
  end

  def parse_push(push_abbrev)
    letters = push_abbrev.split('')
    direction = DIRECTION_ABBREVS[letters[0]] || raise('Path contains an invalid direction letter!')
    slot = SLOT_ABBREVS[letters[1]] || raise('Slot contains an invalid slot letter!')
    return direction, slot
  end

  def parse_path(path_abbrev)
    path_abbrev.split('').map do |letter|
      DIRECTION_ABBREVS[letter] || raise('Path contains an invalid direction letter!')
    end
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
