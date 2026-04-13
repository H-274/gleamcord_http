import component/interactive
import gleam/dict.{type Dict}
import message_component/interaction.{type Interaction}
import message_component/response.{type Response}

// TODO create proper handlers
pub type MessageComponent(state) {
  Button(signature: interactive.CustomButton, handler: ButtonHandler(state))
  StringSelect(
    signature: interactive.StringSelect,
    handler: SelectHandler(state, List(String)),
  )
  UserSelect(
    signature: interactive.UserSelect,
    handler: SelectHandler(state, List(String)),
  )
  RoleSelect(
    signature: interactive.RoleSelect,
    handler: SelectHandler(state, List(String)),
  )
  MentionableSelect(
    signature: interactive.MentionableSelect,
    handler: SelectHandler(state, List(String)),
  )
  ChannelSelect(
    signature: interactive.ChannelSelect,
    handler: SelectHandler(state, List(String)),
  )
}

pub type ButtonHandler(state) =
  fn(Interaction, state) -> Response(state)

pub type SelectHandler(state, values) =
  fn(Interaction, state, values) -> Response(state)

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
        Ok(StringSelect(handler:, ..)) ->
          handler(i, state, select.values)
          |> Ok
        _ -> Error(Nil)
      }
    interaction.UserSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(UserSelect(handler:, ..)) ->
          handler(i, state, select.values)
          |> Ok
        _ -> Error(Nil)
      }
    interaction.RoleSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(RoleSelect(handler:, ..)) ->
          handler(i, state, select.values)
          |> Ok
        _ -> Error(Nil)
      }
    interaction.MentionableSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(MentionableSelect(handler:, ..)) ->
          handler(i, state, select.values) |> Ok
        _ -> Error(Nil)
      }
    interaction.ChannelSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(ChannelSelect(handler:, ..)) ->
          handler(i, state, select.values) |> Ok
        _ -> Error(Nil)
      }
  }
}
