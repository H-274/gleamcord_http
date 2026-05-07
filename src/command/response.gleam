import gleam/json.{type Json}
import message
import modal/modal

pub type Response(state) {
  MessageWithSource(message.New)
  DeferredMessageWithSource(fn() -> message.New)
  Modal(modal.Modal(state))
}

pub fn json(response: Response(state)) -> Json {
  case response {
    MessageWithSource(n) -> [
      #("type", json.int(4)),
      #("data", message.new_json(n)),
    ]
    DeferredMessageWithSource(n) -> [
      #("type", json.int(5)),
      #("data", message.new_json(n())),
    ]
    Modal(m) -> [#("type", json.int(9)), #("data", modal.json(m))]
  }
  |> json.object
}

pub type AutocompleteResponse {
  StringAutocomplete(List(#(String, String)))
  IntegerAutocomplete(List(#(String, Int)))
  NumberAutocomplete(List(#(String, Float)))
}
