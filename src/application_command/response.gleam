//// Based on:
//// - https://docs.discord.com/developers/interactions/receiving-and-responding#interaction-response-object

pub type Response {
  MessageWithSource(String)
  DeferredMessageWithSource(fn() -> String)
  Modal
}

pub type AutocompleteResponse {
  StringAutocomplete(List(#(String, String)))
  IntegerAutocomplete(List(#(String, Int)))
  NumberAutocomplete(List(#(String, Float)))
}
