defmodule Covidgraph.Chart do
  alias Contex.{Dataset, LinePlot, Plot, TimeScale, Scale}

  def draw(map_list, from_dt, to_dt) do
    line_plot =
      map_list
      |> Dataset.new(["x", "Nombre de morts"])
      |> LinePlot.new(custom_x_scale: create_timescale({from_dt, to_dt}, {0, 100}))

    plot =
      Plot.new(600, 450, line_plot)
      |> Plot.plot_options(%{legend_setting: :legend_right})
      |> Plot.titles("Total deaths in France", "")
      |> Plot.axis_labels("Date", "Décés")

    Plot.to_xml(plot)
  end

  defp create_timescale({d_min, d_max} = _domain, {r_min, r_max} = _range) do
    TimeScale.new()
    |> Scale.set_range(r_min, r_max)
    |> TimeScale.domain(d_min, d_max)
  end
end
