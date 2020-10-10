ExUnit.start()
#Ecto.Adapters.SQL.Sandbox.mode(Apperback.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)
Mongo.drop_collection(:mongo, "projects")