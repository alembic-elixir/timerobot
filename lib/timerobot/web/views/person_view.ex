defmodule Timerobot.Web.PersonView do
  use Timerobot.Web, :view

  def calculate_totals(times) do
    times
    |> Enum.reduce(0, fn({_date, _project, hours}, sum) -> sum + hours end)
  end

  def calculate_days(times) do
    hours = calculate_totals(times)
    hours_in_day = 8
    days = hours/hours_in_day
    Float.ceil(days * 4) / 4
  end

  def daily_hours(beginning_of_week, times) do
    0..6
    |> Enum.map(fn(day_offset) ->
      day = Timex.shift(beginning_of_week, days: day_offset)
      hours =
        times
        |> Enum.filter(fn({date, _project, _hours}) -> date == day end)
        |> Enum.reduce(0, fn({_date, _project, hours}, sum) -> sum + hours end)
      {day, hours}
    end)
  end
end
