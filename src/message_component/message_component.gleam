import component/interactive
import gleam/dict.{type Dict}
import message_component/interaction.{type Interaction}
import message_component/response.{type Response}

// TODO create proper handlers
pub type MessageComponent(state) {
  Button(signature: interactive.CustomButton, handler: ButtonHandler(state))
  StringSelect(
    signature: interactive.StringSelect,
    handler: SelectHandler(state, Nil),
  )
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

pub fn handle_interaction(
  components: Dict(String, MessageComponent(state)),
  state: state,
  i: Interaction,
) {
  case i.data {
    interaction.Button(button) ->
      case dict.get(components, button.custom_id) {
        Ok(Button(handler:, ..)) -> handler(i, state) |> Ok
        _ -> Error(Nil)
      }
    interaction.StringSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(StringSelect(handler:, ..)) -> todo |> Ok
        _ -> Error(Nil)
      }
    interaction.UserSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(UserSelect(handler:, ..)) -> todo |> Ok
        _ -> Error(Nil)
      }
    interaction.RoleSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(RoleSelect(handler:, ..)) -> todo |> Ok
        _ -> Error(Nil)
      }
    interaction.MentionableSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(MentionableSelect(handler:, ..)) -> todo |> Ok
        _ -> Error(Nil)
      }
    interaction.ChannelSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(ChannelSelect(handler:, ..)) -> todo |> Ok
        _ -> Error(Nil)
      }
  }
}
