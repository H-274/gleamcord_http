import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleamcord_http/component/interactive
import gleamcord_http/message
import gleamcord_http/message_component/interaction.{type Interaction}
import gleamcord_http/modal.{type Modal}

// TODO create proper handlers
pub type MessageComponent {
  Button(signature: interactive.CustomButton, handler: ButtonHandler)
  StringSelect(
    signature: interactive.StringSelect,
    handler: SelectHandler(List(String)),
  )
  UserSelect(
    signature: interactive.UserSelect,
    handler: SelectHandler(#(List(Dynamic), List(Dynamic))),
  )
  RoleSelect(
    signature: interactive.RoleSelect,
    handler: SelectHandler(List(Dynamic)),
  )
  MentionableSelect(
    signature: interactive.MentionableSelect,
    handler: SelectHandler(#(List(Dynamic), List(Dynamic), List(Dynamic))),
  )
  ChannelSelect(
    signature: interactive.ChannelSelect,
    handler: SelectHandler(List(Dynamic)),
  )
}

pub fn to_tuple(component: MessageComponent) {
  case component {
    Button(signature:, ..) -> #(signature.custom_id, component)
    StringSelect(signature:, ..) -> #(signature.custom_id, component)
    UserSelect(signature:, ..) -> #(signature.custom_id, component)
    RoleSelect(signature:, ..) -> #(signature.custom_id, component)
    MentionableSelect(signature:, ..) -> #(signature.custom_id, component)
    ChannelSelect(signature:, ..) -> #(signature.custom_id, component)
  }
}

pub type Response {
  MessageResponse(message.New)
  DeferredMessageResponse(fn() -> message.New)
  UpdateResponse(message.New)
  DeferredUpdateResponse(fn() -> message.New)
  ModalResponse(Modal)
}

pub type ButtonHandler =
  fn(Interaction) -> Response

// TODO move values to second param to match commands
pub type SelectHandler(values) =
  fn(Interaction, values) -> Response

pub fn handle_interaction(
  components: Dict(String, MessageComponent),
  i: Interaction,
) {
  case i.data {
    interaction.Button(button) ->
      case dict.get(components, button.custom_id) {
        Ok(Button(handler:, ..)) -> handler(i) |> Ok
        _ -> Error(Nil)
      }
    interaction.StringSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(StringSelect(handler:, ..)) ->
          handler(i, select.values)
          |> Ok
        _ -> Error(Nil)
      }
    interaction.UserSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(UserSelect(handler:, ..)) ->
          handler(i, select.resolved)
          |> Ok
        _ -> Error(Nil)
      }
    interaction.RoleSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(RoleSelect(handler:, ..)) ->
          handler(i, select.resolved)
          |> Ok
        _ -> Error(Nil)
      }
    interaction.MentionableSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(MentionableSelect(handler:, ..)) -> handler(i, select.resolved) |> Ok
        _ -> Error(Nil)
      }
    interaction.ChannelSelect(select) ->
      case dict.get(components, select.custom_id) {
        Ok(ChannelSelect(handler:, ..)) -> handler(i, select.resolved) |> Ok
        _ -> Error(Nil)
      }
  }
}
