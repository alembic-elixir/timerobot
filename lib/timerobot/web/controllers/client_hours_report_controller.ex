defmodule Timerobot.Web.ClientHoursReportController do
  use Timerobot.Web, :controller

  alias Timerobot.Timesheet

  def index(conn, _params) do
    projects = Timesheet.project_hours_for_week(~D[2017-05-10])
    render conn, "index.html",
      projects: projects
  end

  def project(conn, %{"id" => id}) do
    project = Timesheet.get_project!(id)
    render conn, "show.html",
      project: project
  end

end
