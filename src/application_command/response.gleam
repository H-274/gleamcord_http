//// Based on:
//// - https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object

import message
import modal/modal.{type Modal}

pub type Response(state) {
  MessageWithSource(message.New)
  DeferredMessageWithSource(fn() -> message.New)
  Modal(Modal(state))
}

pub type AutocompleteResponse {
  StringAutocomplete(List(#(String, String)))
  IntegerAutocomplete(List(#(String, Int)))
  NumberAutocomplete(List(#(String, Float)))
}
