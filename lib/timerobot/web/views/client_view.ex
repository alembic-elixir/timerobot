defmodule Timerobot.Web.ClientView do
  use Timerobot.Web, :view

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
