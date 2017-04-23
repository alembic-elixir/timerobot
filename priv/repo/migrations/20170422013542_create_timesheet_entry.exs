defmodule Timerobot.Repo.Migrations.CreateTimerobot.Timesheet.Entry do
  use Ecto.Migration

  def change do
    create table(:timesheet_entry) do
      add :date, :date
      add :hours, :integer
      add :project_id, references(:timesheet_project, on_delete: :nothing)
      add :person_id, references(:timesheet_person, on_delete: :nothing)

      timestamps()
    end

    create index(:timesheet_entry, [:project_id])
    create index(:timesheet_entry, [:person_id])
  end
end
