defmodule Timerobot.Web.ReportView do
  use Timerobot.Web, :view

  def calculate_days(hours) do
    hours_in_day = 8
    days = hours/hours_in_day
    Float.ceil(days * 4) / 4
  end
end
