import component/interactive.{
  ChannelSelect, MentionableSelect, PrimaryButton, RoleSelect, StringSelect,
  UserSelect,
}
import emoji
import gleam/dynamic.{type Dynamic}
import gleam/option
import gleam/string
import message
import message_component/message_component as component

pub fn button() {
  use _interaction, _state <- component.Button(PrimaryButton(
    custom_id: "slow-update",
    label: "Slow",
    disabled: False,
    emoji: option.None,
  ))

  use <- component.DeferredUpdateResponse

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
      emoji: option.Some(
        emoji.Partial(id: "", name: "thumbsup", animated: False),
      ),
      default: False,
    ),
    interactive.SelectOption(
      label: "opt2",
      value: "b",
      description: "",
      emoji: option.Some(
        emoji.Partial(id: "", name: "hand_splayed", animated: False),
      ),
      default: False,
    ),
    interactive.SelectOption(
      label: "opt3",
      value: "c",
      description: "",
      emoji: option.Some(
        emoji.Partial(id: "", name: "thumbsdown", animated: False),
      ),
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
  |> component.MessageResponse
}

pub fn user_select() {
  use _interaction, _state, values <- component.UserSelect(UserSelect)
  let users: List(Dynamic) = values.0
  let members: List(Dynamic) = values.1

  echo #(users, members)

  { "Submitted successfully" }
  |> message.NewText([])
  |> component.MessageResponse
}

pub fn role_select() {
  use _interaction, _state, values <- component.RoleSelect(RoleSelect)
  let roles: List(Dynamic) = values

  echo roles

  { "Submitted successfully" }
  |> message.NewText([])
  |> component.MessageResponse
}

pub fn mentionable_select() {
  use _interaction, _state, values <- component.MentionableSelect(
    MentionableSelect,
  )
  let users: List(Dynamic) = values.0
  let members: List(Dynamic) = values.1
  let roles: List(Dynamic) = values.2

  echo #(users, members, roles)

  { "Submitted successfully" }
  |> message.NewText([])
  |> component.MessageResponse
}

pub fn channel_select() {
  use _interaction, _state, values <- component.ChannelSelect(ChannelSelect)
  let channels: List(Dynamic) = values

  echo channels

  { "Submitted successfully" }
  |> message.NewText([])
  |> component.MessageResponse
}
