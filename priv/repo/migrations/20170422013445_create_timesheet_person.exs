defmodule Timerobot.Repo.Migrations.CreateTimerobot.Timesheet.Person do
  use Ecto.Migration

  def change do
    create table(:timesheet_person) do
      add :name, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:timesheet_person, [:name])
    create unique_index(:timesheet_person, [:slug])
  end
end
