defmodule Timerobot.Web.EntryController do
  use Timerobot.Web, :controller

  alias Timerobot.Timesheet
  alias Timerobot.Timesheet.{Person, Project}

  def index(conn, params) do
    entry = Timesheet.list_entry()
    render conn, "index.html",
      entry: entry
  end

  def new(conn, params) do

    changeset = Timesheet.change_entry(%Timerobot.Timesheet.Entry{})

    render conn, "new.html",
      changeset: changeset,
      people: Timesheet.all_people_dropdown,
      projects: Timesheet.all_projects_dropdown
  end

  def create(conn, %{"entry" => entry_params}) do

    case Timesheet.create_entry(entry_params) do
      {:ok, entry} ->
        conn
        |> put_flash(:info, "Entry created successfully.")
        |> redirect(to: entry_path(conn, :show, entry))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "new.html",
          changeset: changeset,
          people: Timesheet.all_people_dropdown,
          projects: Timesheet.all_projects_dropdown
    end
  end

  def show(conn, %{"id" => id}) do
    entry = Timesheet.get_entry!(id)
    render conn, "show.html",
      entry: entry
  end

  def edit(conn, %{"id" => id}) do

    entry = Timesheet.get_entry!(id)
    changeset = Timesheet.change_entry(entry)
    render conn, "edit.html",
      entry: entry,
      changeset: changeset,
      people: Timesheet.all_people_dropdown,
      projects: Timesheet.all_projects_dropdown
  end

  def update(conn, %{"id" => id, "entry" => entry_params}) do

    entry = Timesheet.get_entry!(id)

    case Timesheet.update_entry(entry, entry_params) do
      {:ok, entry} ->
        conn
        |> put_flash(:info, "Entry updated successfully.")
        |> redirect(to: entry_path(conn, :show, entry))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "edit.html",
          entry: entry,
          changeset: changeset,
          people: Timesheet.all_people_dropdown,
          projects: Timesheet.all_projects_dropdown
    end
  end

  def delete(conn, %{"id" => id}) do
    entry = Timesheet.get_entry!(id)
    {:ok, _entry} = Timesheet.delete_entry(entry)

    conn
    |> put_flash(:info, "Entry deleted successfully.")
    |> redirect(to: entry_path(conn, :index))
  end
end
