defmodule Timerobot.Repo.Migrations.UpdatePassword do
  use Ecto.Migration

  def up do
    password =
      Comeonin.Bcrypt.hashpwsalt(
        System.get_env("ADMIN_PASSWORD") || "admin"
      )

    execute """
      UPDATE timesheet_person
      SET encrypted_password = '#{password}'
      WHERE encrypted_password IS NULL OR encrypted_password = '';
    """

    execute """
      ALTER TABLE timesheet_person
      ALTER COLUMN encrypted_password SET NOT NULL;
    """
  end

  def down do
  end
end
