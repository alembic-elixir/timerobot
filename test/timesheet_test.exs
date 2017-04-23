defmodule Timerobot.TimesheetTest do
  use Timerobot.DataCase

  alias Timerobot.Timesheet
  alias Timerobot.Timesheet.Client

  @create_attrs %{name: "some name", slug: "some slug"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}

  def fixture(:client, attrs \\ @create_attrs) do
    {:ok, client} = Timesheet.create_client(attrs)
    client
  end

  test "list_client/1 returns all client" do
    client = fixture(:client)
    assert Timesheet.list_client() == [client]
  end

  test "get_client! returns the client with given id" do
    client = fixture(:client)
    assert Timesheet.get_client!(client.id) == client
  end

  test "create_client/1 with valid data creates a client" do
    assert {:ok, %Client{} = client} = Timesheet.create_client(@create_attrs)
    assert client.name == "some name"
    assert client.slug == "some slug"
  end

  test "create_client/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Timesheet.create_client(@invalid_attrs)
  end

  test "update_client/2 with valid data updates the client" do
    client = fixture(:client)
    assert {:ok, client} = Timesheet.update_client(client, @update_attrs)
    assert %Client{} = client
    assert client.name == "some updated name"
    assert client.slug == "some updated slug"
  end

  test "update_client/2 with invalid data returns error changeset" do
    client = fixture(:client)
    assert {:error, %Ecto.Changeset{}} = Timesheet.update_client(client, @invalid_attrs)
    assert client == Timesheet.get_client!(client.id)
  end

  test "delete_client/1 deletes the client" do
    client = fixture(:client)
    assert {:ok, %Client{}} = Timesheet.delete_client(client)
    assert_raise Ecto.NoResultsError, fn -> Timesheet.get_client!(client.id) end
  end

  test "change_client/1 returns a client changeset" do
    client = fixture(:client)
    assert %Ecto.Changeset{} = Timesheet.change_client(client)
  end
end
