import gleam/json.{type Json}
import gleamcord_http.{type Modal}
import gleamcord_http/command
import gleamcord_http/message
import gleamcord_http/message_component

pub type MessageWithSource =
  message.New

pub type DeferredMessageWithSource =
  fn() -> message.New

pub type UpdateMessage =
  message.New

pub type DeferredUpdateMessage =
  fn() -> message.New

pub type Response {
  Pong
  MessageWithSource(MessageWithSource)
  DeferredMessageWithSource(DeferredMessageWithSource)
  UpdateMessage(UpdateMessage)
  DeferredUpdateMessage(DeferredUpdateMessage)
  Autocomplete(command.Autocomplete)
  Modal(Modal)
}

pub fn json(response: Response) -> Json {
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
    Modal(m) -> [
      #("type", json.int(9)),
      #("data", gleamcord_http.modal_json(m)),
    ]
  }
  |> json.object
}

pub fn map_command(response: command.Response) {
  case response {
    command.MessageResponse(r) -> MessageWithSource(r)
    command.DeferredMessageResponse(r) -> DeferredMessageWithSource(r)
    command.ModalResponse(r) -> Modal(r)
  }
}

pub fn map_message_component(response: message_component.Response) {
  case response {
    message_component.MessageResponse(r) -> MessageWithSource(r)
    message_component.DeferredMessageResponse(r) -> DeferredMessageWithSource(r)
    message_component.UpdateResponse(r) -> UpdateMessage(r)
    message_component.DeferredUpdateResponse(r) -> DeferredUpdateMessage(r)
    message_component.ModalResponse(r) -> Modal(r)
  }
}

pub fn map_modal(response: gleamcord_http.ModalResponse) {
  case response {
    gleamcord_http.MessageResponse(r) -> MessageWithSource(r)
    gleamcord_http.DeferredMessageResponse(r) -> DeferredMessageWithSource(r)
    gleamcord_http.UpdateResponse(r) -> UpdateMessage(r)
    gleamcord_http.DeferredUpdateResponse(r) -> DeferredUpdateMessage(r)
  }
}
