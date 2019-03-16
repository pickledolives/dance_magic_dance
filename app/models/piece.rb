class Piece

  PASSAGE_TYPES = %i(north east south west)

  attr_reader :passages, :card_symbol

  def initialize(passages = nil, card_symbol = nil)
    passages = parse_passages(passages) if passages.is_a?(String)
    @passages = passages || random_passages
    @card_symbol = card_symbol
  end

  def parse_passages(passages_abbrev)
    passages = []
    passages << :north if passages_abbrev.include?('n')
    passages << :east if passages_abbrev.include?('e')
    passages << :south if passages_abbrev.include?('s')
    passages << :west if passages_abbrev.include?('w')
    passages.sort
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
    s << " with '#{@card_symbol}'" unless @card_symbol.nil?
    s << " open at: #{@passages.join(', ')}"
  end
end
