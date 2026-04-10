import modal/modal.{type Modal}

pub type Response(state) {
  MessageWithSource(String)
  DeferredMessageWithSource(fn() -> String)
  UpdateMessage(String)
  DeferredUpdateMessage(fn() -> String)
  Modal(Modal(state))
}
