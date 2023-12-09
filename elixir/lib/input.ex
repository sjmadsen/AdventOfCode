defmodule Input do
  def from_string(string), do: get_lines(string)

  def from_file(f) do
    {:ok, string} = File.read(f)
    get_lines(string)
  end

  def get_lines(string) do
    String.trim(string)
    |> String.split("\n")
  end
end
