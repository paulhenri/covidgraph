defmodule Covidgraph.Datas do
  @endpoint "https://raw.githubusercontent.com/opencovid19-fr/data/master/dist/chiffres-cles.json"
  @user_agent [{"User-agent", "Covidgraph"}]

  def fetch_datas do
    HTTPoison.get(@endpoint, @user_agent)
  end

  def get(from, to) do
    fetch_datas()
    |> toMap
    |> filter(from, to)
  end

  def toMap({:ok, %HTTPoison.Response{body: datas}}) do
    datas
    |> Jason.decode()
  end

  def toMap({:error, %HTTPoison.Error{id: _, reason: erreur}}) do
    IO.puts("An error occured while retriving datas -- #{erreur}")
    System.halt(2)
  end

  def filter({:ok, map}, from_dt, to_dt) do
    IO.puts(" Filtering from #{from_dt} to #{to_dt}")

    map
    |> Stream.filter(fn x ->
      case DateTime.from_iso8601("#{x["date"]}T00:00:00Z") do
        {:ok, _date, _offsset} ->
          if x["nom"] == "France" do
            true
          else
            false
          end

        _ ->
          false
      end
    end)
    |> Stream.map(fn x ->
      {:ok, date, _offset} = DateTime.from_iso8601("#{x["date"]}T00:00:00Z")
      {date, x["deces"]}
    end)
    |> Stream.filter(fn x ->
      elem(x, 1) != nil && DateTime.compare(elem(x, 0), from_dt) == :gt &&
        DateTime.compare(elem(x, 0), to_dt) == :lt
    end)
    |> Enum.to_list()
  end

  def filter({:error, err}) do
    IO.puts("An error occured while converting datas from JSON to Map -- #{err}")
    System.halt(2)
  end
end
