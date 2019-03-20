  # frozen_string_literal: true

class Player
  attr_reader :name, :image, :cards, :completed_cards
  attr_accessor :piece, :last_move, :last_move_trace

  def initialize(name, image)
    @name = name
    @image = image
  end

  def enter_game!(cards)
    @cards = [Game::START_CARDS[@name]] + cards
    @piece = Game::FIXED_PIECES[@name]
    @piece.add_player(self)
    @completed_cards = []
    @last_move = []
    @last_move_trace = []
  end

  def won?
    @cards.empty?
  end

  def current_card
    @cards.last
  end

  def reached_current_card?
    current_card == @piece.card
  end

  def complete_card!
    @completed_cards.push(@cards.pop)
  end
end
