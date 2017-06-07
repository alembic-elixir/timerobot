defmodule Timerobot.TimesheetTest do
  use Timerobot.DataCase

  alias Timerobot.Timesheet
  alias Timerobot.Timesheet.Client
  alias Timerobot.Timesheet.Entry

  @create_attrs %{"name" => "some name"}
  @update_attrs %{"name" => "some updated name", "slug" => "some-updated-name"}
  @invalid_attrs %{"name" => nil}

  def fixture(:client, attrs \\ @create_attrs) do
    {:ok, client} = Timesheet.create_client(attrs)
    client
  end

  test "all_clients/1 returns all client" do
    client = fixture(:client)
    assert Timesheet.all_clients() == [client]
  end

  test "get_client! returns the client with given id" do
    client = fixture(:client)
    assert Timesheet.get_client!(client.slug).slug == client.slug
  end

  test "create_client/1 with valid data creates a client" do
    assert {:ok, %Client{} = client} = Timesheet.create_client(@create_attrs)
    assert client.name == "some name"
    assert client.slug == "some-name"
  end

  test "create_client/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Timesheet.create_client(@invalid_attrs)
  end

  test "update_client/2 with valid data updates the client" do
    client = fixture(:client)
    assert {:ok, client} = Timesheet.update_client(client, @update_attrs)
    assert %Client{} = client
    assert client.name == "some updated name"
    assert client.slug == "some-updated-name"
  end

  test "update_client/2 with invalid data returns error changeset" do
    client = fixture(:client)
    assert {:error, %Ecto.Changeset{}} = Timesheet.update_client(client, @invalid_attrs)
    assert client.slug == Timesheet.get_client!(client.slug).slug
  end

  test "delete_client/1 deletes the client" do
    client = fixture(:client)
    assert {:ok, %Client{}} = Timesheet.delete_client(client)
    assert_raise Ecto.NoResultsError, fn -> Timesheet.get_client!(client.slug) end
  end

  test "change_client/1 returns a client changeset" do
    client = fixture(:client)
    assert %Ecto.Changeset{} = Timesheet.change_client(client)
  end

  test "test entries_for_person" do
    assert Timesheet.entries_for_person([]) == []
    assert Timesheet.entries_for_person([
      %Entry{person: "person1", date: ~D[2000-01-01], project: "test", hours: 8}
    ]) == [{~D[1999-12-27], [{~D[2000-01-01], "test", 8}]}]
    assert Timesheet.entries_for_person([
      %Entry{person: "person1", date: ~D[2000-01-01], project: "test", hours: 8},
      %Entry{person: "person2", date: ~D[2000-01-01], project: "test", hours: 8},
    ]) == [{~D[1999-12-27], [{~D[2000-01-01], "test", 16}]}]
    assert Timesheet.entries_for_person([
      %Entry{person: "person1", date: ~D[2000-01-01], project: "test", hours: 8},
      %Entry{person: "person2", date: ~D[2000-01-01], project: "test", hours: 8},
      %Entry{person: "person1", date: ~D[2000-01-02], project: "test", hours: 2},
      %Entry{person: "person2", date: ~D[2000-01-02], project: "test", hours: 2},
    ]) == [
      {~D[1999-12-27], [
        {~D[2000-01-01], "test", 16},
        {~D[2000-01-02], "test", 4}
      ]}
    ]
    assert Timesheet.entries_for_person([
      %Entry{person: "person1", date: ~D[2000-01-01], project: "project1", hours: 8},
      %Entry{person: "person2", date: ~D[2000-01-01], project: "project2", hours: 8},
    ]) == [{~D[1999-12-27], [
      {~D[2000-01-01], "project2", 8},
      {~D[2000-01-01], "project1", 8}
    ]}]
  end

  test "test entries_for_project" do
    assert Timesheet.entries_for_project([]) == []
    assert Timesheet.entries_for_project([
      %Entry{person: "person1", date: ~D[2000-01-01], project: "project1", hours: 8}
    ]) == [{~D[1999-12-27], [{~D[2000-01-01], "person1", 8}]}]
    assert Timesheet.entries_for_project([
      %Entry{person: "person1", date: ~D[2000-01-01], project: "project1", hours: 8},
      %Entry{person: "person2", date: ~D[2000-01-01], project: "project2", hours: 8},
    ]) == [{~D[1999-12-27], [
      {~D[2000-01-01], "person2", 8},
      {~D[2000-01-01], "person1", 8}
    ]}]
    assert Timesheet.entries_for_project([
      %Entry{person: "person1", date: ~D[2000-01-01], project: "project1", hours: 8},
      %Entry{person: "person1", date: ~D[2000-01-01], project: "project2", hours: 8},
    ]) == [{~D[1999-12-27], [{~D[2000-01-01], "person1", 16}]}]
    assert Timesheet.entries_for_project([
      %Entry{person: "person1", date: ~D[2000-01-01], project: "test", hours: 8},
      %Entry{person: "person1", date: ~D[2000-01-01], project: "test", hours: 8},
      %Entry{person: "person2", date: ~D[2000-01-02], project: "test", hours: 2},
      %Entry{person: "person2", date: ~D[2000-01-02], project: "test", hours: 2},
    ]) == [
      {~D[1999-12-27], [
        {~D[2000-01-01], "person1", 16},
        {~D[2000-01-02], "person2", 4}
      ]}
    ]
  end
end
