defmodule Timerobot.Timesheet.Person do
  use Ecto.Schema

  alias Timerobot.Timesheet.Entry

  schema "timesheet_person" do
    field :name, :string
    field :slug, :string

    has_many :project, Entry

    timestamps()
  end
end
