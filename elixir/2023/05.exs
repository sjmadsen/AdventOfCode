defmodule Day5 do
  @sample """
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
  """

  defmodule Mapping do
    defstruct source: nil, destination: nil, length: 0

    def convert(value, []), do: value
    def convert(value, [range = %Mapping{} | rest]) do
      if value >= range.source && value < range.source + range.length do
        range.destination + (value - range.source)
      else
        convert(value, rest)
      end
    end
  end

  defp input do
    # @sample
    {:ok, lines} = File.read("2023/data/05.txt")
    lines
    |> String.trim
    |> String.split("\n\n")
  end

  def part1 do
    input = input()
    [seeds | input] = parse_seeds_part1(input)
    find_location(seeds, input)
    |> IO.puts
  end

  def find_location(seeds, input) do
    [seed_to_soil | input] = parse_mapping(input)
    [soil_to_fertilizer | input] = parse_mapping(input)
    [fertilizer_to_water | input] = parse_mapping(input)
    [water_to_light | input] = parse_mapping(input)
    [light_to_temperature | input] = parse_mapping(input)
    [temperature_to_humidity | input] = parse_mapping(input)
    [humidity_to_location | _] = parse_mapping(input)

    IO.puts("Considering #{Enum.count(seeds)} seeds")
    Enum.map(seeds, fn seed ->
      Mapping.convert(seed, seed_to_soil)
      |> Mapping.convert(soil_to_fertilizer)
      |> Mapping.convert(fertilizer_to_water)
      |> Mapping.convert(water_to_light)
      |> Mapping.convert(light_to_temperature)
      |> Mapping.convert(temperature_to_humidity)
      |> Mapping.convert(humidity_to_location)
    end)
    |> Enum.min
  end

  defp parse_seeds_part1([section | rest]) do
    [_, numbers] = String.split(section, ~r/seeds: /)
    [parse_numbers(numbers) | rest]
  end

  defp parse_mapping([section | rest]) do
    [_ | lines] = String.split(section, "\n")
    mapping = Enum.map(lines, fn line ->
      [destination, source, length] = parse_numbers(line)
      %Mapping{source: source, destination: destination, length: length}
    end)
    [mapping | rest]
  end

  defp parse_numbers(line) do
    String.split(line, " ")
    |> Enum.map(&(String.to_integer(&1)))
  end

  def part2 do
    input = input()
    [seeds | input] = parse_seeds_part2(input)
    find_location(seeds, input)
    |> IO.puts
  end

  defp parse_seeds_part2([section | rest]) do
    [_, numbers] = String.split(section, ~r/seeds: /)
    seeds = parse_numbers(numbers)
    |> Enum.chunk_every(2)
    |> Enum.reduce([], fn [start, length], list ->
      build_int_list(start, length) ++ list
    end)
    [seeds | rest]
  end

  defp build_int_list(_value, 0), do: []
  defp build_int_list(value, remaining) do
    [value | build_int_list(value + 1, remaining - 1)]
  end
end

Day5.part1
Day5.part2
