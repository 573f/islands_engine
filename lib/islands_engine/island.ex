defmodule IslandsEngine.Island do
  @moduledoc """
  Islands are represented as a list of coordinates that conform to a known shape, or type.
  Coordinates that have been successfully identified through the course of the game are
  captured in the hit coordinates list. If the island and hit coordinates match completely,
  then the island is forested.
  """
  alias IslandsEngine.{Coordinate, Island}

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  @doc """
  Creates a new Island from a specified shape atom and an upper left coordinate.
  The island coordinate list is created by applying the island's shape offsets to
  the upper left coordinate.
  """
  def new(type, %Coordinate{} = upper_left) do
    with [_ | _] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  @doc """
  Checks to see if two islands overlap. Overlap occurs when two islands share a common coordinate.
  Therefore, we can determine overlap by checking if the coordinate MapSets are disjoint.
  """
  def overlaps?(existing_island, new_island),
    do: not MapSet.disjoint?(existing_island.coordinates, new_island.coordinates)

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  @doc """
  Determines if the supplied coordinate is part of the specified island.
  If so, the coordinate is added to the island's hit coordinates.
  """
  def guess(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
        {:hit, %{island | hit_coordinates: hit_coordinates}}

      false ->
        :miss
    end
  end

  @doc """
  Determines if the island is forested, that is, have all the island's coordinates been guessed, or "hit"?
  """
  def forested?(island), do: MapSet.equal?(island.coordinates, island.hit_coordinates)

  @doc """
  Valid island shapes.
  """
  def types(), do: [:atoll, :dot, :l_shape, :s_shape, :square]

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} -> {:cont, MapSet.put(coordinates, coordinate)}
      {:error, :invalid_coordinate} -> {:halt, {:error, :invalid_coordinate}}
    end
  end

  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offsets(:dot), do: [{0, 0}]
  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offsets(_), do: {:error, :invalid_island_type}
end
