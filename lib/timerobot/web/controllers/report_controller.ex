defmodule Timerobot.Web.ReportController do
  use Timerobot.Web, :controller

  alias Timerobot.Timesheet

  def report(conn, report_params = %{"report" => %{"date" => date_string}}) do
    do_report conn, Timex.parse!(date_string, "%Y-%m-%d", :strftime)
  end

  def report(conn, params) do
    do_report conn, Timex.now
  end

  defp do_report(conn, date) do
    {beginning_of_week, end_of_week} =
      Timesheet.week_for_date(date)

    data =
      date
      |> Timesheet.entries_for_week
      |> Timesheet.entries_for_project

    render conn, "report.html",
      data: data,
      week_list: Timesheet.weeks(4),
      beginning_of_week: Timex.format!(beginning_of_week, "{WDfull} {D} {Mfull} {YYYY}")
  end

end
