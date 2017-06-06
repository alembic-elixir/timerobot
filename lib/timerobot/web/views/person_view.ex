defmodule Timerobot.Web.PersonView do
  use Timerobot.Web, :view

  def project_dailies(beginning_of_week, project_times) do
    0..6
    |> Enum.map(fn(day_offset) ->
      day = Timex.shift(beginning_of_week, days: day_offset)
      hours =
        project_times
        |> Enum.filter(&(elem(&1, 0) == day))
        |> Enum.reduce(0, &(elem(&1, 2) + &2))
      {day, hours}
    end)
  end

  def project_totals(project_times) do
    project_times
    |> Enum.reduce(0, &(elem(&1, 2) + &2))
  end

  def calculate_totals(times) do
    times
    |> Enum.reduce(0, fn({_date, _entry, hours}, sum) -> sum + hours end)
  end
end
