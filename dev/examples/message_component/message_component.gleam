import component/interactive.{
  ChannelSelect, MentionableSelect, PrimaryButton, RoleSelect, StringSelect,
  UserSelect,
}
import gleam/dynamic.{type Dynamic}
import gleam/option
import gleam/string
import message
import message_component/message_component as component
import message_component/response as c_response

pub fn button() {
  use _interaction, _state <- component.Button(PrimaryButton(
    custom_id: "slow-update",
    label: "Slow",
    disabled: False,
    emoji: option.None,
  ))

  use <- c_response.DeferredUpdateMessage()

  // process.sleep(5000)

  "Updated message!"
  |> message.NewText([])
}

const interactive_string_select = StringSelect(
  custom_id: "string-select-mc",
  options: [
    interactive.SelectOption(
      label: "opt1",
      value: "a",
      description: "",
      emoji: option.None,
      default: False,
    ),
    interactive.SelectOption(
      label: "opt2",
      value: "b",
      description: "",
      emoji: option.None,
      default: False,
    ),
    interactive.SelectOption(
      label: "opt3",
      value: "c",
      description: "",
      emoji: option.None,
      default: False,
    ),
  ],
  placeholder: "Pick some options",
  min_values: 1,
  max_values: 3,
  required: False,
  disabled: False,
)

pub fn string_select() {
  use _interaction, _state, values <- component.StringSelect(
    interactive_string_select,
  )

  { "You selected:\n" <> string.join(values, ", ") }
  |> message.NewText([])
  |> c_response.MessageWithSource
}

pub fn user_select() {
  use _interaction, _state, values <- component.UserSelect(UserSelect)
  let _users: List(Dynamic) = values.0
  let _members: List(Dynamic) = values.1

  { "Submitted successfully" }
  |> message.NewText([])
  |> c_response.MessageWithSource
}

pub fn role_select() {
  use _interaction, _state, values <- component.RoleSelect(RoleSelect)
  let _roles: List(Dynamic) = values

  { "Submitted successfully" }
  |> message.NewText([])
  |> c_response.MessageWithSource
}

pub fn mentionable_select() {
  use _interaction, _state, values <- component.MentionableSelect(
    MentionableSelect,
  )
  let _users: List(Dynamic) = values.0
  let _members: List(Dynamic) = values.1
  let _roles: List(Dynamic) = values.2

  { "Submitted successfully" }
  |> message.NewText([])
  |> c_response.MessageWithSource
}

pub fn channel_select() {
  use _interaction, _state, values <- component.ChannelSelect(ChannelSelect)
  let _channels: List(Dynamic) = values

  { "Submitted successfully" }
  |> message.NewText([])
  |> c_response.MessageWithSource
}
