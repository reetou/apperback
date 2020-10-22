defmodule Apperback.ProjectBuild.Android do
  def variables(%{
        keystore_jks_path: keystore_path,
        key_password: key_pass,
        keystore_password: keystore_pass,
        keystore_alias: keystore_alias,
        bundle_id: bundle_id
      }) do
    keystore_jks = keystore_path |> File.read!() |> Base.encode64()

    [
      %{key: "KEYSTORE_JKS", variable_type: "env_var", value: keystore_jks},
      %{key: "KEYSTORE_PASSWORD", variable_type: "env_var", value: keystore_pass},
      %{key: "KEY_PASSWORD", variable_type: "env_var", value: key_pass},
      %{key: "KEYSTORE_ALIAS", variable_type: "env_var", value: keystore_alias},
      %{key: "BUNDLE_ID", variable_type: "env_var", value: bundle_id}
    ]
  end
end
