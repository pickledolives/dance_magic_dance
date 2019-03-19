# frozen_string_literal: true

module RenderBoard

  def self.call(board)
    puts '-' * 50
    board.each do |row_of_pieces|
      row_of_tiles = row_of_pieces.map { |piece| RenderPieceTile.call(piece) }
      (0..2).map { |i_of_tiles_row| puts '|' + row_of_tiles.map { |tile| tile[i_of_tiles_row] + ['|'] }.join }
      puts '-' * 50
    end
  end
end
