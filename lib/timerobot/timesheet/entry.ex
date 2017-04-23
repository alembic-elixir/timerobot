defmodule Timerobot.Timesheet.Entry do
  use Ecto.Schema

  schema "timesheet_entry" do
    field :date, :date
    field :hours, :integer
    field :project, :id
    field :person, :id

    timestamps()
  end
end
