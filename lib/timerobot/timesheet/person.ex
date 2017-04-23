defmodule Timerobot.Timesheet.Person do
  use Ecto.Schema

  schema "timesheet_person" do
    field :name, :string
    field :slug, :string

    timestamps()
  end
end
