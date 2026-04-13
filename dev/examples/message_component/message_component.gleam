import component/interactive.{
  ChannelSelect, MentionableSelect, PrimaryButton, RoleSelect, StringSelect,
  UserSelect,
}
import gleam/dynamic.{type Dynamic}
import gleam/option
import gleam/string
import message_component/message_component as mc
import message_component/response as mcr

pub fn button() {
  use _i, _state <- mc.Button(PrimaryButton(
    custom_id: "slow-update",
    label: "Slow",
    emoji: option.None,
  ))

  use <- mcr.DeferredUpdateMessage()

  // process.sleep(5000)

  "Updated message!"
}

pub fn string_select() {
  use _i, _state, values <- mc.StringSelect(StringSelect)

  { "You selected:\n" <> string.join(values, "\n") }
  |> mcr.MessageWithSource
}

pub fn user_select() {
  use _i, _state, values <- mc.UserSelect(UserSelect)
  let _users: List(Dynamic) = values.0
  let _members: List(Dynamic) = values.1

  { "Submitted successfully" }
  |> mcr.MessageWithSource
}

pub fn role_select() {
  use _i, _state, values <- mc.RoleSelect(RoleSelect)
  let _roles: List(Dynamic) = values

  { "Submitted successfully" }
  |> mcr.MessageWithSource
}

pub fn mentionable_select() {
  use _i, _state, values <- mc.MentionableSelect(MentionableSelect)
  let _users: List(Dynamic) = values.0
  let _members: List(Dynamic) = values.1
  let _roles: List(Dynamic) = values.2

  { "Submitted successfully" }
  |> mcr.MessageWithSource
}

pub fn channel_select() {
  use _i, _state, values <- mc.ChannelSelect(ChannelSelect)
  let _channels: List(Dynamic) = values

  { "Submitted successfully" }
  |> mcr.MessageWithSource
}
