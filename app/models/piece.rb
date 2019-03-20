# frozen_string_literal: true

class Piece

  attr_reader :passages, :card, :players

  def initialize(passages = nil, card = nil, players = [])
    @passages = passages || random_passages!
    @card = card
    @players = players
  end

  def remove_player(player)
    @players -= [player]
  end

  def add_player(player)
    @players += [player]
  end

  def passages=(passages)
    raise 'Invalid piece orientation' unless types.include?(passages.sort)
    @passages = passages.sort
  end

  def random_passages!
    @passages = types[rand(types.length)]
  end

  def to_s
    s = name.to_s
    s << " with '#{@card.name}'" unless @card.nil?
    s << " with players #{@players.map(&:name).join(', ')}" if @players.any?
    s << " with passages #{@passages.join(', ')}"
  end
end
