defmodule LVLUp.Repo.Migrations.CreatePrompts do
  use Ecto.Migration

  def change do
    create table(:prompts) do
      add :text, :string, null: false
      add :status, :string, null: false, default: "created"

      timestamps()
    end
  end
end
