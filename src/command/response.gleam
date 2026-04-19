import message
import modal/modal

pub type Response(state) {
  MessageWithSource(message.New)
  DeferredMessageWithSource(fn() -> message.New)
  Modal(modal.Modal(state))
}

pub type AutocompleteResponse {
  StringAutocomplete(List(#(String, String)))
  IntegerAutocomplete(List(#(String, Int)))
  NumberAutocomplete(List(#(String, Float)))
}
