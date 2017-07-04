defmodule Timerobot.Timesheet.Person do
  use Ecto.Schema

  alias Timerobot.Timesheet.Entry
  alias Timerobot.Timesheet.Project

  schema "timesheet_person" do
    field :name, :string
    field :slug, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    has_many :projects, Project
    has_many :entries, Entry

    timestamps()
  end
end
