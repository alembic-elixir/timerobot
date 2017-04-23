defmodule Timerobot.Timesheet.Client do
  use Ecto.Schema

  alias Timerobot.Timesheet.Project

  schema "timesheet_client" do
    field :name, :string
    field :slug, :string

    has_many :project, Project
    timestamps()
  end
end
