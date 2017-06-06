defmodule Timerobot.Web.ProjectView do
  use Timerobot.Web, :view

  def calculate_totals(times) do
    times
    |> Enum.reduce(0, fn({_date, _entry, hours}, sum) -> sum + hours end)
  end
end
