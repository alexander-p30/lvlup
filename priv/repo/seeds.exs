# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LVLUp.Repo.insert!(%LVLUp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LVLUp.Skills.SkillCategory
alias LVLUp.Repo

build_skill_category = fn title, description, color ->
  now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

  %{title: title, description: description, color: color, inserted_at: now, updated_at: now}
end

skill_categories = [
  build_skill_category.("Exercise", "Move body", "#333333"),
  build_skill_category.("Study", "Flex brain", "#555555")
]

Repo.insert_all(SkillCategory, skill_categories)
