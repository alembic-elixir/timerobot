defmodule Timerobot.Timesheet.Project do
  use Ecto.Schema

  schema "timesheet_project" do
    field :name, :string
    field :slug, :string
    field :client, :id

    timestamps()
  end
end
