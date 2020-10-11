defmodule ApperbackWeb.ErrorView do
  use ApperbackWeb, :view

  defp error_gettext(detail) when is_atom(detail) or is_binary(detail) do
    Gettext.dgettext(ApperbackWeb.Gettext, "errors", "#{detail}")
  end

  defp error_gettext(_detail) do
    Gettext.dgettext(ApperbackWeb.Gettext, "errors", "unknown error")
  end

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("401.json", %{detail: detail}) do
    %{errors: %{detail: error_gettext(detail)}}
  end

  def render("401.json", _assigns) do
    %{errors: %{detail: error_gettext("need_to_login")}}
  end

  def render("403.json", %{detail: detail}) do
    %{errors: %{detail: error_gettext(detail)}}
  end

  def render("403.json", _assigns) do
    %{errors: %{detail: error_gettext("unauthorized")}}
  end

  def render("404.json", %{detail: detail}) do
    %{errors: %{detail: error_gettext(detail)}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: error_gettext("resource_not_found")}}
  end

  def render("400.json", %{detail: detail}) do
    %{errors: %{detail: error_gettext(detail)}}
  end

  def render("400.json", _assigns) do
    %{errors: %{detail: error_gettext("invalid_params")}}
  end

  def render("500.json", %{detail: detail}) do
    %{errors: %{detail: error_gettext(detail)}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: error_gettext("invalid_params")}}
  end

  def error(code, assigns \\ %{}) do
    render("#{code}.json", assigns)
  end
end
