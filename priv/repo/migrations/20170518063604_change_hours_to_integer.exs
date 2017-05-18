defmodule Timerobot.Repo.Migrations.ChangeHoursToInteger do
  use Ecto.Migration

  def change do
      alter table(:timesheet_entry) do
        modify :hours, :float
      end
  end
end
