class Field
  MAX_INDEX = 6
  MAX_SIZE = 7

  FIXED_PIECES = [
    [CurvePiece.new('se', :blue), nil, CrossingPiece.new('wse', :helmet), nil, CrossingPiece.new('wse', :candelabra), nil, CurvePiece.new('sw', :green)],
    [nil, nil, nil, nil, nil, nil, nil],
    [CrossingPiece.new('nes', :sword), nil, CrossingPiece.new('nes', :emerald), nil, CrossingPiece.new('esw', :treasure_chest), nil, CrossingPiece.new('nsw', :ring)],
    [nil, nil, nil, nil, nil, nil, nil],
    [CrossingPiece.new('nes', :skull), nil, CrossingPiece.new('ewn', :keys), nil, CrossingPiece.new('nws', :crown), nil, CrossingPiece.new('nws', :map)],
    [nil, nil, nil, nil, nil, nil, nil],
    [CurvePiece.new('ne', :yellow), nil, CrossingPiece.new('ewn', :money_bag), nil, CrossingPiece.new('ewn', :book), nil, CurvePiece.new('nw', :red)]
  ]

  FREE_PIECES = (1..13).map { StraightPiece.new } + (1..9).map { CurvePiece.new } + [CurvePiece.new(nil, :mouse), CurvePiece.new(nil, :salamander), CurvePiece.new(nil, :spider), CurvePiece.new(nil, :scarab), CurvePiece.new(nil, :moth), CurvePiece.new(nil, :owl)] + [CrossingPiece.new(nil, :bat), CrossingPiece.new(nil, :dragon), CrossingPiece.new(nil, :witch), CrossingPiece.new(nil, :gini), CrossingPiece.new(nil, :ghost), CrossingPiece.new(nil, :leprechaun)]

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

  attr_reader :board, :piece_in_play

  def initialize
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
