defmodule Timerobot.Web.ClientHoursReportController do
  use Timerobot.Web, :controller

  alias Timerobot.Timesheet

  def new(conn, _params) do
    changeset = Timesheet.new_client_hours_report_changeset(%Timesheet.ClientHoursReport{})
    render conn, "new.html",
      changeset: changeset,
      dates: Timesheet.client_hours_report_date_range
  end
end
