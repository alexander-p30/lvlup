defmodule LVLUp.Repo.Migrations.CreateScores do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :number, :integer, check: "number >= 0 AND number <= 5", null: false

      add :prompt_id, references(:prompts), null: false
      add :skill_category_id, references(:skill_categories), null: false

      timestamps()
    end

    create unique_index(:scores, [:prompt_id, :skill_category_id])
  end
end
