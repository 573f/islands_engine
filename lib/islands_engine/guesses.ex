defmodule IslandsEngine.Guesses do
  @moduledoc """
  Guesses represent the opponent's board as a collection of coordinates grouped into hits and misses.
  """
  alias IslandsEngine.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @doc """
  Creates a new, empty Guesses struct where the hits and misses are MapSets to enforce unique values.
  """
  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  @doc """
  Adds a guess coordinate to the appropriate collecion.
  """
  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate),
    do: update_in(guesses.hits, &MapSet.put(&1, coordinate))

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate),
    do: update_in(guesses.misses, &MapSet.put(&1, coordinate))
end
