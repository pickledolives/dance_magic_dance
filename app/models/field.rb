class Field
  MAX_INDEX = 6
  MAX_SIZE = 7

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
    [CurvePiece.new('se', STARTS[:blue]), nil, CrossingPiece.new('wse', CARDS[:helmet]), nil, CrossingPiece.new('wse', CARDS[:candelabra]), nil, CurvePiece.new('sw', STARTS[:green])],
    [nil, nil, nil, nil, nil, nil, nil],
    [CrossingPiece.new('nes', CARDS[:sword]), nil, CrossingPiece.new('nes', CARDS[:emerald]), nil, CrossingPiece.new('esw', CARDS[:treasure]), nil, CrossingPiece.new('nsw', CARDS[:ring])],
    [nil, nil, nil, nil, nil, nil, nil],
    [CrossingPiece.new('nes', CARDS[:skull]), nil, CrossingPiece.new('ewn', CARDS[:keys]), nil, CrossingPiece.new('nws', CARDS[:crown]), nil, CrossingPiece.new('nws', CARDS[:map])],
    [nil, nil, nil, nil, nil, nil, nil],
    [CurvePiece.new('ne', STARTS[:yellow]), nil, CrossingPiece.new('ewn', CARDS[:money_bag]), nil, CrossingPiece.new('ewn', CARDS[:book]), nil, CurvePiece.new('nw', STARTS[:red])]
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

  attr_reader :board, :piece_in_play, :player_cards

  def initialize(player_count)
    cards_per_player = CARDS.size / player_count
    cards_stack = CARDS.values.shuffle
    players = STARTS.first(player_count).to_h
    @player_cards = players.map do |color, start_card|
      [color, [start_card] + cards_stack.shift(cards_per_player)]
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

  def push_at(direction, position, passages = nil)
    push_id = "#{direction}_#{position}".to_sym
    push = PUSHABLES[push_id]
    raise "cannot push there" if push.nil?
    raise "cannot reverse push" if push[:opposite_of] == @last_push

    passages.nil? ? @piece_in_play.random_passages : @piece_in_play.passages = passages
    case direction.to_sym
    when :north then push_down(push[:x])
    when :east then push_left(push[:y])
    when :south then push_up(push[:x])
    when :west then push_right(push[:y])
    end
    @last_push = push_id
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

  def push_down(x)
    moving_piece = @piece_in_play
    replacing_piece = nil
    MAX_SIZE.times do |i|
      replacing_piece = moving_piece
      moving_piece = @board[i][x]
      @board[i][x] = replacing_piece
    end
    @piece_in_play = moving_piece
  end

  def push_left(y)
    @board[y].push(@piece_in_play)
    @piece_in_play = @board[y].shift
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
    @piece_in_play = moving_piece
  end

  def push_right(y)
    @board[y].unshift(@piece_in_play)
    @piece_in_play = @board[y].pop
  end
end
