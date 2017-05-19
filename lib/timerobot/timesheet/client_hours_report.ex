defmodule Timerobot.Timesheet.ClientHoursReport do
  use Ecto.Schema

  embedded_schema do
    field :week_starting, :date
  end

end
