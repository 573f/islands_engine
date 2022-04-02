defmodule IslandsEngine.Coordinate do
  @moduledoc """
  Coordinate definition. A coordinate consists of a row and column value, each within the range 1..10,
  """
  alias __MODULE__

  @enforce_keys [:row, :col]
  defstruct [:row, :col]

  @board_range 1..10

  @doc """
  Creates a new Coordinate struct given row and col values.
  """
  def new(row, col) when row in @board_range and col in @board_range,
    do: {:ok, %Coordinate{row: row, col: col}}

  def new(_row, _col), do: {:error, :invalid_coordinate}
end
