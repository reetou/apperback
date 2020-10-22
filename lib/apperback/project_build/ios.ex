defmodule Apperback.ProjectBuild.Ios do
  def variables(%{
        p12_cert_path: p12_path,
        provisioning_profile_path: profile_path,
        p12_password: p12_pass,
        apple_team_id: apple_team_id,
        bundle_id: bundle_id
      }) do
    p12_cert = p12_path |> File.read!() |> Base.encode64()
    provisioning_profile = profile_path |> File.read!() |> Base.encode64()

    [
      %{key: "P12_CERT", variable_type: "env_var", value: p12_cert},
      %{key: "PROVISIONING_PROFILE", variable_type: "env_var", value: provisioning_profile},
      %{key: "P12_PASSWORD", variable_type: "env_var", value: p12_pass},
      %{key: "APPLE_TEAM_ID", variable_type: "env_var", value: apple_team_id},
      %{key: "BUNDLE_ID", variable_type: "env_var", value: bundle_id}
    ]
  end
end
