defmodule Rpgdemo.Repo.Migrations.CreateSkillCategories do
  use Ecto.Migration

  def change do
    create table(:skill_categories) do
      add :title, :string, null: false, size: 30
      add :color, :string, null: false, size: 7
      add :description, :text, null: false
      add :status, :string, null: false, default: "active"

      timestamps()
    end

    create unique_index(:skill_categories, :title, where: "status = 'active'")
    create unique_index(:skill_categories, :color, where: "status = 'active'")
  end
end
