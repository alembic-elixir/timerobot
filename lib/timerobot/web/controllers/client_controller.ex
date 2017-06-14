defmodule Timerobot.Web.ClientController do
  use Timerobot.Web, :controller

  alias Timerobot.Timesheet

  def index(conn, _params) do
    render conn, "index.html",
      clients: Timesheet.all_clients
  end

  def new(conn, _params) do
    changeset = Timesheet.change_client(%Timerobot.Timesheet.Client{})
    render conn, "new.html",
      changeset: changeset
  end

  def create(conn, %{"client" => client_params}) do
    case Timesheet.create_client(client_params) do
      {:ok, client} ->
        conn
        |> put_flash(:info, "Client created successfully.")
        |> redirect(to: client_path(conn, :show, client.slug))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "new.html",
          changeset: changeset
    end
  end

  def show(conn, %{"slug" => slug}) do
    client = Timesheet.get_client!(slug)
    data = Timesheet.sort_client_entries(slug)
    render conn, "show.html",
      client: client,
      data: data,
      projects: client.projects
  end

  def edit(conn, %{"slug" => slug}) do
    client = Timesheet.get_client!(slug)
    changeset = Timesheet.change_client(client)
    render conn, "edit.html",
      client: client,
      changeset: changeset
  end

  def update(conn, %{"slug" => slug, "client" => client_params}) do
    client = Timesheet.get_client!(slug)

    case Timesheet.update_client(client, client_params) do
      {:ok, client} ->
        conn
        |> put_flash(:info, "Client updated successfully.")
        |> redirect(to: client_path(conn, :show, client.slug))
      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, "edit.html",
          client: client,
          changeset: changeset
    end
  end

  def delete(conn, %{"slug" => slug}) do
    client = Timesheet.get_client!(slug)
    {:ok, _client} = Timesheet.delete_client(client)

    conn
    |> put_flash(:info, "Client deleted successfully.")
    |> redirect(to: client_path(conn, :index))
  end
end
