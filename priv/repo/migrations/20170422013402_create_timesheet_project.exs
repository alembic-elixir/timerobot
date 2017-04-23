defmodule Timerobot.Repo.Migrations.CreateTimerobot.Timesheet.Project do
  use Ecto.Migration

  def change do
    create table(:timesheet_project) do
      add :name, :string
      add :slug, :string
      add :client_id, references(:timesheet_client, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:timesheet_project, [:name])
    create unique_index(:timesheet_project, [:slug])
    create index(:timesheet_project, [:client_id])
  end
end
