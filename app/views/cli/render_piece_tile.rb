# frozen_string_literal: true

module RenderPieceTile

  WALL = "\u2588\u2588"
  FREE = '  '
  BASE_TILE = [
    [WALL, WALL, WALL].freeze,
    [WALL, FREE, WALL].freeze,
    [WALL, WALL, WALL].freeze
  ].freeze

  def self.call(piece)
    player_names = piece.players.map(&:name)
    tile = BASE_TILE.map(&:dup)
    tile[1][1] = piece.card.image unless piece.card.nil?
    tile[0][1] = FREE if piece.passages.include?(:north)
    tile[1][2] = FREE if piece.passages.include?(:east)
    tile[2][1] = FREE if piece.passages.include?(:south)
    tile[1][0] = FREE if piece.passages.include?(:west)
    tile[0][0] = Game::PLAYERS[:blue].image if player_names.include?(:blue)
    tile[0][2] = Game::PLAYERS[:green].image if player_names.include?(:green)
    tile[2][0] = Game::PLAYERS[:yellow].image if player_names.include?(:yellow)
    tile[2][2] = Game::PLAYERS[:red].image if player_names.include?(:red)
    tile
  end
end
