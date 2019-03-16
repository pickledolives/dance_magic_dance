class CurvePiece < Piece
  TYPES = [
    %i(east north),
    %i(east south),
    %i(south west),
    %i(north west)
  ]

  def name
    'curve'
  end

  def types
    TYPES
  end
end
