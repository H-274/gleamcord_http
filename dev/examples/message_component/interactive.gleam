import gleam/list
import gleam/option
import gleam/string
import message_component/button/interaction_button
import message_component/interactive
import message_component/response as component_response

pub fn button() {
  use _i, _state <- interaction_button.PrimaryButton(
    custom_id: "tos-agree",
    label: "Agree",
    emoji: option.None,
    disabled: False,
  )

  "Agreement registered"
  |> component_response.MessageWithSource
}

pub fn string_select() {
  let options = [
    interactive.SelectOption(
      label: "Anouncements",
      value: "anouncements",
      description: "Get pings for anouncements",
      emoji: option.None,
      default: False,
    ),
    // Others ...
  ]

  use _i, _state, values <- interactive.StringSelect(
    custom_id: "roles",
    options:,
    placeholder: "Roles",
    min_values: 1,
    max_values: list.length(options),
    required: True,
    disabled: False,
  )

  { "Subscribed to: \n" <> string.join(values, with: "\n") }
  |> component_response.MessageWithSource
}
