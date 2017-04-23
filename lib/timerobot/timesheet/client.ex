defmodule Timerobot.Timesheet.Client do
  use Ecto.Schema

  schema "timesheet_client" do
    field :name, :string
    field :slug, :string

    timestamps()
  end
end
