defmodule Timerobot.Web.ProjectView do
  use Timerobot.Web, :view

  def person_dailies(beginning_of_week, person_times) do
    0..6
    |> Enum.map(fn(day_offset) ->
      day = Timex.shift(beginning_of_week, days: day_offset)
      hours =
        person_times
        |> Enum.filter(&(elem(&1, 0) == day))
        |> Enum.reduce(0, &(elem(&1, 2) + &2))
      {day, hours}
    end)
  end

  def person_totals(person_times) do
    person_times
    |> Enum.reduce(0, &(elem(&1, 2) + &2))
  end

  def calculate_totals(times) do
    times
    |> Enum.reduce(0, fn({_date, _entry, hours}, sum) -> sum + hours end)
  end
end
