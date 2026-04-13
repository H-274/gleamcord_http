import message
import modal/modal.{type Modal}

pub type Response(state) {
  MessageWithSource(message.New)
  DeferredMessageWithSource(fn() -> message.New)
  UpdateMessage(message.New)
  DeferredUpdateMessage(fn() -> message.New)
  Modal(Modal(state))
}
