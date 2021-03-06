defmodule Annon.Plugins.Validator.SettingsValidator do
  @moduledoc """
  Validation rules for Validator plugin settings.
  """
  import Annon.Plugin.JsonSchemaValidator

  def validate_settings(%Ecto.Changeset{} = changeset) do
    validate_with_json_schema(changeset, :settings, settings_validation_schema())
  end

  def settings_validation_schema do
    %{
      "type" => "object",
      "required" => ["rules"],
      "additionalProperties" => false,
      "properties" => %{
        "rules" => %{
          "type" => "array",
          "minItems" => 1,
          "uniqueItems" => true,
          "items" => %{
            "type" => "object",
            "required" => ["methods", "path", "schema"],
            "properties" => %{
              "methods" => %{
                "type" => "array",
                "minItems" => 1,
                "items" => %{
                  "type" => "string",
                  "enum" => ["POST", "PUT", "PATCH"]
                }
              },
              "path" => %{
                "type" => "string",
                "minLength" => 1,
                "pattern" => "^(?!\\^).*"
              },
              "schema" => %{
                "type" => "object"
              }
            }
          }
        }
      }
    }
  end
end
