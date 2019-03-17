class Piece

  BASE_TILE = [
    ['##', '##', '##'].freeze,
    ['##', '  ', '##'].freeze,
    ['##', '##', '##'].freeze
  ].freeze

  attr_reader :passages, :card

  def initialize(passages = nil, card = nil)
    passages = parse_passages(passages) if passages.is_a?(String)
    @passages = passages || random_passages
    @card = card
  end

  def passages=(passages)
    passages = parse_passages(passages) if passages.is_a?(String)
    raise 'invalid piece orientation' unless types.include?(passages.sort) 
    @passages = passages
  end

  def random_passages
    @passages = types[rand(types.length)]
  end

  def to_s
    s = name
    s << " with '#{@card.name}'" unless @card.nil?
    s << " open at: #{@passages.join(', ')}"
  end

  def render_tile
    tile = BASE_TILE.map(&:dup)
    tile[1][1] = @card.image unless @card.nil?
    tile[0][1] = '  ' if @passages.include?(:north)
    tile[1][2] = '  ' if @passages.include?(:east)
    tile[2][1] = '  ' if @passages.include?(:south)
    tile[1][0] = '  ' if @passages.include?(:west)
    tile
  end

  private

  def parse_passages(passages_abbrev)
    passages = []
    passages << :north if passages_abbrev.include?('n')
    passages << :east if passages_abbrev.include?('e')
    passages << :south if passages_abbrev.include?('s')
    passages << :west if passages_abbrev.include?('w')
    passages.sort
  end
end
