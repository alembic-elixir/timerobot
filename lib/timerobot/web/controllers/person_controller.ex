defmodule Timerobot.Web.PersonController do
  use Timerobot.Web, :controller

  alias Timerobot.Timesheet

  def index(conn, _params) do
    person = Timesheet.list_person()
    render(conn, "index.html", person: person)
  end

  def new(conn, _params) do
    changeset = Timesheet.change_person(%Timerobot.Timesheet.Person{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"person" => person_params}) do
    case Timesheet.create_person(person_params) do
      {:ok, person} ->
        conn
        |> put_flash(:info, "Person created successfully.")
        |> redirect(to: person_path(conn, :show, person))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    person = Timesheet.get_person!(id)
    render(conn, "show.html", person: person)
  end

  def edit(conn, %{"id" => id}) do
    person = Timesheet.get_person!(id)
    changeset = Timesheet.change_person(person)
    render(conn, "edit.html", person: person, changeset: changeset)
  end

  def update(conn, %{"id" => id, "person" => person_params}) do
    person = Timesheet.get_person!(id)

    case Timesheet.update_person(person, person_params) do
      {:ok, person} ->
        conn
        |> put_flash(:info, "Person updated successfully.")
        |> redirect(to: person_path(conn, :show, person))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", person: person, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    person = Timesheet.get_person!(id)
    {:ok, _person} = Timesheet.delete_person(person)

    conn
    |> put_flash(:info, "Person deleted successfully.")
    |> redirect(to: person_path(conn, :index))
  end
end