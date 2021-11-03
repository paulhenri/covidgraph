defmodule Covidgraph.CLI do
  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  def parse_args(argv) do
    OptionParser.parse(argv, switches: [from: :string, to: :string, out: :string])
    # To get the valid list
    |> elem(0)
    |> validate_args
  end

  def validate_args(from: from, to: to, out: out) do
    date_from =
      "#{String.slice(from, 0..3)}-#{String.slice(from, 4..5)}-#{String.slice(from, 6..7)}"
      |> Date.from_iso8601()

    date_to =
      "#{String.slice(to, 0..3)}-#{String.slice(to, 4..5)}-#{String.slice(to, 6..7)}"
      |> Date.from_iso8601()

    represent_args_to_internal(date_from, date_to, out)
  end

  def validate_args(_) do
    :help
  end

  def represent_args_to_internal({:ok, from}, {:ok, to}, out)
      when from <= to do
    {from, to, out}
  end

  def represent_args_to_internal({:ok, _from}, {:ok, _to}, _out) do
    {:error, "Date from is superior to date To "}
  end

  def represent_args_to_internal({:error, _}, {:ok, _}, _) do
    {:error, "From date is invalid - Should be like YYYYMMDD"}
  end

  def represent_args_to_internal({:ok, _}, {:error, _}, _) do
    {:error, "To date is invalid - Should be like YYYYMMDD"}
  end

  def process(:help) do
    IO.puts("""
      Usage: covidgraph --from AAAAMMDD --to AAAAMMDD --out path/to/output_folder
      From date must be lower or equal to To date
    """)
  end

  def process({from, to, out}) do
    {:ok, from_dt, _offset} = DateTime.from_iso8601("#{from}T00:00:00Z")
    {:ok, to_dt, _offset} = DateTime.from_iso8601("#{to}T00:00:00Z")

    svg_graph =
      Covidgraph.Datas.get(from_dt, to_dt)
      |> Covidgraph.Chart.draw(from_dt, to_dt)

    File.write("#{out}/graph.svg", svg_graph)

    File.write("#{out}/graph.html", """
    <html>
      <head>
      </head>
      <body>
      #{svg_graph}
      </body>
    </html>
    """)
  end

  def process({:error, erreur}) do
    IO.puts(erreur)
    System.halt(1)
  end
end
