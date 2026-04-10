import component/interactive
import message_component/interaction.{type Interaction}
import message_component/response.{type Response}

// TODO create proper handlers
pub type MessageComponent(state) {
  Button(signature: interactive.CustomButton, handler: ButtonHandler(state))
  UserSelect(
    signature: interactive.UserSelect,
    handler: SelectHandler(state, Nil),
  )
  RoleSelect(
    signature: interactive.RoleSelect,
    handler: SelectHandler(state, Nil),
  )
  MentionableSelect(
    signature: interactive.MentionableSelect,
    handler: SelectHandler(state, Nil),
  )
  ChannelSelect(
    signature: interactive.ChannelSelect,
    handler: SelectHandler(state, Nil),
  )
}

pub type ButtonHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type SelectHandler(state, t)
