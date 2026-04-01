//// Based on:
//// - https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object

import modal/modal.{type Modal}

pub type Response(state) {
  MessageWithSource(String)
  DeferredMessageWithSource(fn() -> String)
  Modal(Modal(state))
}

pub type AutocompleteResponse {
  StringAutocomplete(List(#(String, String)))
  IntegerAutocomplete(List(#(String, Int)))
  NumberAutocomplete(List(#(String, Float)))
}
