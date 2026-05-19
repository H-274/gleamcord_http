import message

pub type Response(modal) {
  Pong
  MessageWithSource(MessageWithSource)
  DeferredMessageWithSource(DeferredMessageWithSource)
  UpdateMessage(UpdateMessage)
  DeferredUpdateMessage(DeferredUpdateMessage)
  Autocomplete(Autocomplete)
  Modal(Modal(modal))
}

pub type MessageWithSource =
  message.New

pub type DeferredMessageWithSource =
  fn() -> message.New

pub type UpdateMessage =
  message.New

pub type DeferredUpdateMessage =
  fn() -> message.New

pub type Modal(modal) =
  modal

pub type Autocomplete {
  StringAutocomplete(List(#(String, String)))
  IntegerAutocomplete(List(#(String, Int)))
  NumberAutocomplete(List(#(String, Float)))
}
