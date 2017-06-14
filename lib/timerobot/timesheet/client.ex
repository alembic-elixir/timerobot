defmodule Timerobot.Timesheet.Client do
  use Ecto.Schema

  alias Timerobot.Timesheet.Project

  schema "timesheet_client" do
    field :name, :string
    field :slug, :string

    has_many :projects, Project
    has_many :entries, through: [:projects, :entries]
    timestamps()
  end
end
