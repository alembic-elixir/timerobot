defmodule Timerobot.Web.ProjectController do
  use Timerobot.Web, :controller

  alias Timerobot.Timesheet
  alias Timerobot.Timesheet.Project

  def index(conn, _params) do
    projects = Timesheet.all_projects()
    render conn, "index.html",
      projects: projects
  end

  def new(conn, _params) do
    render conn, "new.html",
      changeset: Timesheet.change_project(%Project{}),
      clients: Timesheet.all_clients_dropdown
  end

  def create(conn, %{"project" => project_params}) do

    case Timesheet.create_project(project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: project_path(conn, :show, project))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "new.html",
          changeset: changeset,
          clients: Timesheet.all_clients_dropdown
    end
  end

  def show(conn, %{"slug" => slug}) do
    project = Timesheet.get_project!(slug)
    data = Timesheet.sort_project_entries(slug)
    render conn, "show.html",
      project: project,
      data: data
  end

  def edit(conn, %{"slug" => slug}) do
    project = Timesheet.get_project!(slug)
    changeset = Timesheet.change_project(project)
    render conn, "edit.html",
      project: project,
      changeset: changeset,
      clients: Timesheet.all_clients_dropdown
  end

  def update(conn, %{"slug" => slug, "project" => project_params}) do
    project = Timesheet.get_project!(slug)

    case Timesheet.update_project(project, project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project updated successfully.")
        |> redirect(to: project_path(conn, :show, project))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "edit.html",
          project: project,
          changeset: changeset,
          clients: Timesheet.all_clients_dropdown
    end
  end

  def delete(conn, %{"slug" => slug}) do
    project = Timesheet.get_project!(slug)
    {:ok, _project} = Timesheet.delete_project(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: project_path(conn, :index))
  end
end
