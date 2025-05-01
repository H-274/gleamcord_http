import discord/entities/message
import gleam/json.{type Json}
import modal

pub type Response {
  PongResponse(Pong)
  MessageWithSourceResponse(MessageWithSource)
  DeferredMessageWithSourceResponse(DeferredMessageWithSource)
  UpdateMessageResponse(UpdateMessage)
  DeferredUpdateMessageResponse(DeferredUpdateMessage)
  ModalResponse(Modal)
}

pub fn json(response: Response) -> Json {
  todo
}

pub type Pong

pub type MessageWithSource {
  MessageWithSource(message.Message)
}

pub type DeferredMessageWithSource {
  DeferredMessageWithSource(fn() -> message.Message)
}

pub type UpdateMessage {
  UpdateMessage(message.Message)
}

pub type DeferredUpdateMessage {
  DeferredUpdateMessage(fn() -> message.Message)
}

pub type Modal {
  Modal(modal.Modal)
}
