import command/command
import gleam/json.{type Json}
import message
import message_component/message_component
import modal/modal

pub type Response(state) {
  Pong
  MessageWithSource(MessageWithSource)
  DeferredMessageWithSource(DeferredMessageWithSource)
  UpdateMessage(UpdateMessage)
  DeferredUpdateMessage(DeferredUpdateMessage)
  Autocomplete(command.Autocomplete)
  Modal(Modal(state))
}

/// TODO test deferred responses
pub fn json(response: Response(_)) -> Json {
  case response {
    Pong -> [#("type", json.int(1))]
    MessageWithSource(m) -> [
      #("type", json.int(4)),
      #("data", message.new_json(m)),
    ]
    DeferredMessageWithSource(_f) -> [
      #("type", json.int(5)),
    ]
    UpdateMessage(m) -> [#("type", json.int(7)), #("data", message.new_json(m))]
    DeferredUpdateMessage(_f) -> [
      #("type", json.int(6)),
    ]
    Autocomplete(a) -> [
      #("type", json.int(8)),
      #("data", command.autocomplete_json(a)),
    ]
    Modal(m) -> [#("type", json.int(9)), #("data", modal.json(m))]
  }
  |> json.object
}

pub fn map_command(response: command.Response(_)) {
  case response {
    command.MessageResponse(r) -> MessageWithSource(r)
    command.DeferredMessageResponse(r) -> DeferredMessageWithSource(r)
    command.ModalResponse(r) -> Modal(r)
  }
}

pub fn map_message_component(response: message_component.Response(_)) {
  case response {
    message_component.MessageResponse(r) -> MessageWithSource(r)
    message_component.DeferredMessageResponse(r) -> DeferredMessageWithSource(r)
    message_component.UpdateResponse(r) -> UpdateMessage(r)
    message_component.DeferredUpdateResponse(r) -> DeferredUpdateMessage(r)
    message_component.ModalResponse(r) -> Modal(r)
  }
}

pub fn map_modal(response: modal.Response) {
  case response {
    modal.MessageResponse(r) -> MessageWithSource(r)
    modal.DeferredMessageResponse(r) -> DeferredMessageWithSource(r)
    modal.UpdateResponse(r) -> UpdateMessage(r)
    modal.DeferredUpdateResponse(r) -> DeferredUpdateMessage(r)
  }
}

pub type MessageWithSource =
  message.New

pub type DeferredMessageWithSource =
  fn() -> message.New

pub type UpdateMessage =
  message.New

pub type DeferredUpdateMessage =
  fn() -> message.New

pub type Modal(state) =
  modal.Modal(state)
