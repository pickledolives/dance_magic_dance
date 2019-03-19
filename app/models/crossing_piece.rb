# frozen_string_literal: true

class CrossingPiece < Piece
  TYPES = [
    %i(east north south),
    %i(east south west),
    %i(north south west),
    %i(east north west)
  ]

  def name
    :crossing
  end

  def types
    TYPES
  end
end
