import message

pub type Response(state) {
  Pong
  MessageWithSource(MessageWithSource)
  DeferredMessageWithSource(DeferredMessageWithSource)
  UpdateMessage(UpdateMessage)
  DeferredUpdateMessage(DeferredUpdateMessage)
  Modal(Modal(state))
}

pub type MessageWithSource =
  message.New

pub type DeferredMessageWithSource =
  fn() -> message.New

pub type UpdateMessage =
  message.New

pub type DeferredUpdateMessage =
  message.New

pub type Modal(modal) =
  modal
