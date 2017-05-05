defmodule Timerobot.Timesheet.Project do
  use Ecto.Schema

  alias Timerobot.Timesheet.Client
  alias Timerobot.Timesheet.Entry

  schema "timesheet_project" do
    field :name, :string
    field :slug, :string

    belongs_to :client, Client
    has_many :entries, Entry

    timestamps()
  end
end
