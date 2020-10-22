defmodule ApperbackWeb.BuildController do
  alias Apperback.Project
  alias ApperbackWeb.ErrorResponse
  alias Apperback.User
  alias Plug.Upload
  alias Apperback.ProjectBuild.{Ios, Android, Job}
  alias Apperback.ProjectBuild

  use ApperbackWeb, :controller

  plug ApperbackWeb.Plugs.SetProject

  def build_ios(%{assigns: %{current_user: _, project: %Project{id: project_id}}} = conn, %{
        "p12_cert" => %Upload{path: p12_path} = p12,
        "provisioning_profile" => %Upload{path: provisioning_profile_path} = mobile_provision,
        "p12_password" => p12_password,
        "apple_team_id" => apple_team_id,
        "bundle_id" => bundle_id
      }) do

    %Job{} =
      job =
      ProjectBuild.start_build(
        %{
          p12_cert_path: p12_path,
          p12_password: p12_password,
          bundle_id: bundle_id,
          apple_team_id: apple_team_id,
          provisioning_profile_path: provisioning_profile_path
        },
        :ios,
        ProjectBuild.ios_job_name(),
        project_id
      )

    json(conn, %{job: job})
  end

  def build_android(%{assigns: %{current_user: _, project: %Project{id: project_id}}} = conn, %{
        "keystore_jks" => %Upload{path: keystore_jks_path},
        "key_password" => key_password,
        "keystore_password" => keystore_password,
        "keystore_alias" => keystore_alias,
        "bundle_id" => bundle_id
      }) do
    %Job{} =
      job =
      ProjectBuild.start_build(
        %{
          keystore_jks_path: keystore_jks_path,
          key_password: key_password,
          keystore_password: keystore_password,
          keystore_alias: keystore_alias,
          bundle_id: bundle_id
        },
        :android,
        ProjectBuild.android_job_name(),
        project_id
      )

    json(conn, %{job: job})
  end

  def publish_bundle(%{assigns: %{current_user: _, project: %Project{id: project_id}}} = conn, _) do
    %Job{} =
      job = ProjectBuild.start_build(%{}, :general, ProjectBuild.publish_job_name(), project_id)

    json(conn, %{job: job})
  end
end
