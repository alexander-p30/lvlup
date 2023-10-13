# Define mocks
Mox.defmock(LVLUp.Scoring.Engines.EngineMock, for: LVLUp.Scoring.Engine)

# Start stuff/setup db
ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(LVLUp.Repo, :manual)
{:ok, _} = Application.ensure_all_started(:ex_machina)
