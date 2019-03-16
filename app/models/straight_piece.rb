class StraightPiece < Piece
  TYPES = [
    %i(north south),
    %i(east west)
  ]

  def name
    'straight'
  end

  def types
    TYPES
  end
end
