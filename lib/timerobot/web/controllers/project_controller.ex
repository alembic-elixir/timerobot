defmodule Timerobot.Web.ProjectController do
  use Timerobot.Web, :controller

  alias Timerobot.Timesheet
  alias Timerobot.Timesheet.{Client, Entry, Person, Project}

  def index(conn, params) do
    project = Timesheet.list_project()
    render conn, "index.html",
      project: project
  end

  def new(conn, params) do
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

  def show(conn, %{"id" => id}) do
    project = Timesheet.get_project!(id)
    render conn, "show.html",
      project: project
  end

  def edit(conn, %{"id" => id}) do
    project = Timesheet.get_project!(id)
    changeset = Timesheet.change_project(project)
    render conn, "edit.html",
      project: project,
      changeset: changeset,
      clients: Timesheet.all_clients_dropdown
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Timesheet.get_project!(id)

    case Timesheet.update_project(project, project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project updated successfully.")
        |> redirect(to: project_path(conn, :show, project))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "edit.html",
          project: project,
          changeset: changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Timesheet.get_project!(id)
    {:ok, _project} = Timesheet.delete_project(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: project_path(conn, :index))
  end
end
