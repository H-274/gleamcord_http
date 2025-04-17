import discord/context
import discord/integration_type.{GuildIntegration}
import gleam/result
import interaction/application_command
import interaction/application_command_param as param
import interaction/message_component

pub fn chat_input_command() {
  let def =
    application_command.new_definition(
      name: "Hello",
      desc: "world",
      integs: [GuildIntegration],
      contexts: [context.Placeholder],
    )

  let params = [city_param()]

  use _i, params, _bot <- application_command.chat_input_command(def, params)
  let city = result.unwrap(param.get_string(params:, name: "city"), "world")

  Ok("Hello " <> city)
}

fn city_param() {
  let name = "city"
  let builder =
    param.base(name:, desc: "city to greet")
    |> param.required(False)
    |> param.string_builder()
    |> param.string_min_length(2)
    |> param.string_min_length(25)

  use _i, params, _bot <- param.string_with_autocomplete(builder)
  let assert Ok(city) = param.get_string(params:, name:)

  case city {
    "New Y" <> _ -> Ok("New York")
    "New M" <> _ -> Ok("New Mexico")
    _ -> Ok("Toronto")
  }
}

pub fn button_component(disabled: Bool) {
  let def =
    message_component.styled_button(label: "Label", id: "ID")
    |> message_component.styled_button_emoji(Nil)

  use _i, _bot <- message_component.primary_button(def:, disabled:)
  Ok(Nil)
}
