defmodule Timerobot.Web.ReportController do
  use Timerobot.Web, :controller

  alias Timerobot.Timesheet

  def report(conn, %{"report" => %{"date" => date_string}}) do
    do_report conn, Timex.parse!(date_string, "%Y-%m-%d", :strftime)
  end

  def report(conn, _params) do
    do_report conn, Timex.now
  end

  defp do_report(conn, date) do
    {beginning_of_week, _} = Timesheet.week_for_date(date)
    data =
      date
      |> Timesheet.entries_for_week
      |> Timesheet.entries_for_report

    render conn, "report.html",
      data: data,
      week_list: Timesheet.weeks(13),
      beginning_of_week: Timex.format!(beginning_of_week, "{WDfull} {D} {Mfull} {YYYY}")
  end

end
