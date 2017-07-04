defmodule Timerobot.Repo.Migrations.AddEncryptedPasswordToPeople do
  use Ecto.Migration

  def change do
    alter table(:timesheet_person) do
      add :encrypted_password, :string
    end
  end
end
