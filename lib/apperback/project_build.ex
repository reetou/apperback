defmodule Apperback.ProjectBuild do
  alias Apperback.ProjectBuild.{Ios, Android, Job}

  @ios_job_name "run_ios_build"
  @android_job_name "run_android_build"

  def ios_job_name, do: "run_ios_build"
  def android_job_name, do: "run_android_build"
  def publish_job_name, do: "run_publish_bundle"
  defp trigger_token, do: Application.fetch_env!(:apperback, :gitlab_trigger_token)
  defp gitlab_project_id, do: Application.fetch_env!(:apperback, :gitlab_project_id)

  defp headers() do
    [
      {"Content-Type", "application/json"},
      {"PRIVATE-TOKEN", Application.fetch_env!(:apperback, :gitlab_project_access_token)}
    ]
  end

  defp extract_body({:ok, %HTTPoison.Response{status_code: code, body: body}})
       when code in [200, 201] do
    Jason.decode!(body)
  end

  defp pipeline_body(%{} = data, :ios) do
    Jason.encode!(%{
      token: trigger_token(),
      ref: "master",
      variables: Ios.variables(data)
    })
  end

  defp pipeline_body(%{} = data, :android) do
    %{
      token: trigger_token(),
      ref: "master",
      variables: Android.variables(data)
    }
  end

  defp pipeline_body(_, :general) do
    %{
      token: trigger_token(),
      ref: "master",
      variables: []
    }
  end

  def start_build(%{} = data, platform, job_name, project_id)
      when platform in [:ios, :android, :general] do
    data
    |> create_pipeline(platform)
    |> get_job(job_name)
    |> play_job()
    |> Job.assign_project(project_id)
    |> Job.store()
  end

  def create_pipeline(%{} = data, platform) do
    "https://gitlab.com/api/v4/projects/#{gitlab_project_id()}/pipeline"
    |> HTTPoison.post(pipeline_body(data, platform), headers())
    |> extract_body()
  end

  def get_job(%{"id" => pipeline_id}, name) do
    "https://gitlab.com/api/v4/projects/#{gitlab_project_id()}/pipelines/#{pipeline_id}/jobs"
    |> HTTPoison.get(headers())
    |> extract_body()
    |> extract_job(name)
  end

  def extract_job(jobs, name) when is_list(jobs) do
    jobs
    |> Enum.find(fn %{"name" => job_name} ->
      job_name === name
    end)
    |> Job.format()
  end

  def play_job(%Job{id: job_id} = job) do
    "https://gitlab.com/api/v4/projects/#{gitlab_project_id()}/jobs/#{job_id}/play"
    |> HTTPoison.post("", headers())
    |> extract_body()
    |> Job.format()
  end
end
