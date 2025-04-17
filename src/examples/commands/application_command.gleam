import gleam/io
import gleam/result
import interaction/application_command
import interaction/application_command_param as param
import interaction/message_component

pub fn chat_input_command() {
  let def =
    application_command.new_definition(
      name: "Hello",
      desc: "world",
      integs: [Nil],
      contexts: [Nil],
    )

  let params = [city_param()]

  use _i, params, _bot <- application_command.chat_input_command(def, params)
  let city = result.unwrap(param.get_string(params:, name: "city"), "world")

  io.println("Hello " <> city)
  todo as "Response logic"
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
  let assert Ok(_city) = param.get_string(params:, name:)

  todo as "Autocomplete logic"
}

fn button_component(disabled: Bool) {
  let def =
    message_component.styled_button(label: "Label", id: "ID")
    |> message_component.styled_button_emoji(Nil)

  use _i, _bot <- message_component.primary_button(def:, disabled:)
  todo as "Button handler"
}
