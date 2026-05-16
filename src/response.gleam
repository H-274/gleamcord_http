import message

pub type Pong {
  Pong
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
