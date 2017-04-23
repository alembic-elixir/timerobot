defmodule Timerobot.Repo.Migrations.CreateTimerobot.Timesheet.Client do
  use Ecto.Migration

  def change do
    create table(:timesheet_client) do
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:timesheet_client, [:name])
    create unique_index(:timesheet_client, [:slug])
  end
end
