defmodule Timerobot.Timesheet.Entry do
  use Ecto.Schema

  alias Timerobot.Timesheet.Project
  alias Timerobot.Timesheet.Person

  schema "timesheet_entry" do
    field :date, :date
    field :hours, :integer

    belongs_to :project, Project
    belongs_to :person, Person

    timestamps()
  end
end
