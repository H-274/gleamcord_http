import message

pub type Response {
  MessageWithSource(message.New)
  DeferredMessageWithSource(fn() -> message.New)
  UpdateMessage(message.New)
  DeferredUpdateMessage(fn() -> message.New)
}
