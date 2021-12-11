defmodule FermentationSystemWeb.ErrorView do
  use FermentationSystemWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  @spec render(String.t(), map()) :: map()
  def render("error.json", %{changeset_errors: changeset}) do
  errors = Enum.reduce(changeset.errors, "", fn {field, details}, acc -> {reason, _more_details} = details
                                                                           acc <> "#{Atom.to_string(field)} #{reason}, "
  end)

    %{
      status: :failed,
      errors: errors
    }
  end

  def render("error.json", %{reason: reason}) do
    %{
      status: :failed,
      errors: reason
    }
  end
end
