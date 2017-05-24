defmodule Timerobot.Timesheet do
  @moduledoc """
  The boundary for the Timesheet system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Timerobot.Repo

  alias Timerobot.Timesheet.Client
  alias Timerobot.Timesheet.ClientHoursReport
  alias Timerobot.Timesheet.Project
  alias Timerobot.Timesheet.Person
  alias Timerobot.Timesheet.Entry

  @doc """
  Returns the list of clients.

  ## Examples

      iex> list_clients()
      [%Client{}, ...]

  """
  def all_clients do
    Client
    |> order_by([c], c.name)
    |> Repo.all
  end

  def all_clients_dropdown do
    Client
    |> select([c], {c.name, c.id})
    |> order_by([c], c.name)
    |> Repo.all
  end

  @doc """
  Gets a single client.

  Raises `Ecto.NoResultsError` if the Client does not exist.

  ## Examples

      iex> get_client!(123)
      %Client{}

      iex> get_client!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client!(id) do
    Client
    |> Repo.get!(id)
    |> Repo.preload([:projects])
  end

  @doc """
  Creates a client.

  ## Examples

      iex> create_client(%{field: value})
      {:ok, %Client{}}

      iex> create_client(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client(attrs \\ %{}) do
    attrs_with_slug = Map.put(attrs, "slug", Slugger.slugify_downcase(attrs["name"]))
    %Client{}
    |> client_changeset(attrs_with_slug)
    |> Repo.insert()
  end

  @doc """
  Updates a client.

  ## Examples

      iex> update_client(client, %{field: new_value})
      {:ok, %Client{}}

      iex> update_client(client, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client(%Client{} = client, attrs) do
    client
    |> client_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Client.

  ## Examples

      iex> delete_client(client)
      {:ok, %Client{}}

      iex> delete_client(client)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client(%Client{} = client) do
    Repo.delete(client)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client changes.

  ## Examples

      iex> change_client(client)
      %Ecto.Changeset{source: %Client{}}

  """
  def change_client(%Client{} = client) do
    client_changeset(client, %{})
  end

  defp client_changeset(%Client{} = client, attrs) do
    client
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end

  @doc """
  Returns the list of project.

  ## Examples

      iex> list_project()
      [%Project{}, ...]

  """
  def all_projects do
    Project
    |> order_by([p], [p.client_id, p.name])
    |> preload([:client, :entries])
    |> Repo.all
  end

  def all_projects_dropdown do
    Project
    |> join(:inner, [p], c in assoc(p, :client), p.client_id == c.id)
    |> select([p, c], {c.name, p.name, p.id})
    |> order_by([p, c], [c.name, p.name])
    |> Repo.all
    |> Enum.map(fn({client_name, project_name, project_id}) ->
      {"#{client_name} / #{project_name}", project_id}
    end)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id) do
    Project
    |> Repo.get!(id)
    |> Repo.preload([:client, entries: [:person]])
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    attrs_with_slug = Map.put(attrs, "slug", Slugger.slugify_downcase(attrs["name"]))
    %Project{}
    |> project_changeset(attrs_with_slug)
    |> Repo.insert()
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> project_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    project_changeset(project, %{})
  end

  defp project_changeset(%Project{} = project, attrs) do
    project
    |> cast(attrs, [:name, :slug, :client_id])
    |> validate_required([:name, :slug, :client_id])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end

  @doc """
  Returns the list of person.

  ## Examples

      iex> list_person()
      [%Person{}, ...]

  """
  def list_person do
    Person
    |> order_by([p], p.name)
    |> Repo.all
  end

  def all_people_dropdown do
    Person
    |> select([p], {p.name, p.id})
    |> order_by([p], p.name)
    |> Repo.all
  end

  @doc """
  Gets a single person.

  Raises `Ecto.NoResultsError` if the Person does not exist.

  ## Examples

      iex> get_person!(123)
      %Person{}

      iex> get_person!(456)
      ** (Ecto.NoResultsError)

  """
  def get_person!(id) do
    Person
    |> Repo.get!(id)
    |> Repo.preload(entries: [:project])
  end

  @doc """
  Creates a person.

  ## Examples

      iex> create_person(%{field: value})
      {:ok, %Person{}}

      iex> create_person(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_person(attrs \\ %{}) do
    attrs_with_slug = Map.put(attrs, "slug", Slugger.slugify_downcase(attrs["name"]))
    %Person{}
    |> person_changeset(attrs_with_slug)
    |> Repo.insert()
  end

  @doc """
  Updates a person.

  ## Examples

      iex> update_person(person, %{field: new_value})
      {:ok, %Person{}}

      iex> update_person(person, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_person(%Person{} = person, attrs) do
    person
    |> person_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Person.

  ## Examples

      iex> delete_person(person)
      {:ok, %Person{}}

      iex> delete_person(person)
      {:error, %Ecto.Changeset{}}

  """
  def delete_person(%Person{} = person) do
    Repo.delete(person)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking person changes.

  ## Examples

      iex> change_person(person)
      %Ecto.Changeset{source: %Person{}}

  """
  def change_person(%Person{} = person) do
    person_changeset(person, %{})
  end

  defp person_changeset(%Person{} = person, attrs) do
    person
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end

  @doc """
  Returns the list of entry.

  ## Examples

      iex> list_entry()
      [%Entry{}, ...]

  """
  def list_entry do
    Entry
    |> preload([[project: :client], :person])
    |> order_by([e], desc: e.date)
    |> order_by([e], e.project_id)
    |> Repo.all
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(id) do
    Entry
    |> Repo.get!(id)
    |> Repo.preload([:project, :person])
  end

  @doc """
  Creates a entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> entry_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entry.

  ## Examples

      iex> update_entry(entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> entry_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Entry.

  ## Examples

      iex> delete_entry(entry)
      {:ok, %Entry{}}

      iex> delete_entry(entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{source: %Entry{}}

  """
  def change_entry(%Entry{} = entry) do
    entry_changeset(entry, %{})
  end

  defp entry_changeset(%Entry{} = entry, attrs) do
    entry
    |> cast(attrs, [:date, :hours, :person_id, :project_id])
    |> validate_required([:date, :hours, :person_id, :project_id])
  end

  def new_client_hours_report_changeset(%ClientHoursReport{} = client_hours_report) do
    client_hours_report_changeset(client_hours_report, %{})
  end

  defp client_hours_report_changeset(%ClientHoursReport{} = client_hours_report, attrs) do
    client_hours_report
    |> cast(attrs, [:week_starting])
    |> validate_required([:week_starting])
  end

  def client_hours_report_date_range do
    {bow, _} = week_for_date(Timex.now)
    -6..0 |> Enum.map(fn offset ->
      Timex.shift(bow, weeks: offset)
    end)
    |> Enum.map(& Timex.to_date(&1))
    |> Enum.map(fn(date) -> {to_string(date), to_string(date)} end)
    |> Enum.reverse
  end

  def week_for_date(date) do
    beginning_of_week = Timex.beginning_of_week(date, :mon)
    end_of_week = Timex.shift(beginning_of_week, days: 6)
    {beginning_of_week, end_of_week}
  end

  # def entries_for_week(date) do
  #   Entry
  #   # |> preload([[project: :client], :person])
  #   |> join(:left, [e], pr in assoc(e, :project))
  #   |> join(:left, [e], pe in assoc(e, :person))
  #   |> group_by([e, pr, pe], [pr.name, pe.name])
  #   |> select([e, pr, pe], {pr.name, pe.name, sum(e.hours)})
  #   |> Repo.all
  # end

  def entries_for_week(date) do
    {beginning_of_week, end_of_week} = week_for_date(date)
    Entry
    |> preload([[project: :client], :person])
    |> where([e], e.date >= ^beginning_of_week and e.date <= ^end_of_week)
    |> Repo.all
  end

  def entries_for_project(entries) do
    entries
    |> Enum.group_by(& &1.project, &{&1.person.name, &1.date,  &1.hours})
    |> Enum.map(fn {name, times} ->
      {
        name,
        Enum.group_by(times,
          fn {p, date, _hours} -> {p, date} end,
          fn {_p, _date, hours} -> hours end
        ) |> Enum.map(fn {{p, date}, hours} -> {p, date, Enum.sum(hours)} end)
      }
    end)
    |> Enum.group_by(& elem(&1, 0).client.name)
  end

  def entries_for_person(entries) do
    entries
    |> Enum.group_by(& &1.person.name, &{&1.project, &1.date,  &1.hours})
    |> Enum.map(fn {name, times} ->
      {
        name,
        Enum.group_by(times,
        fn {p, date, _hours} -> {p, date} end,
        fn {_p, _date, hours} -> hours end
        ) |> Enum.map(fn {{p, date}, hours} -> {p, date, Enum.sum(hours)} end)
      }
    end)
  end

  def project_hours_for_week(date) do
    date
    |> entries_for_week
    |> entries_for_project
  end

end
