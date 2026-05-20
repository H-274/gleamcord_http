import gleam/json.{type Json}
import message

pub type Response(modal, modal_to_json) {
  Pong
  MessageWithSource(MessageWithSource)
  DeferredMessageWithSource(DeferredMessageWithSource)
  UpdateMessage(UpdateMessage)
  DeferredUpdateMessage(DeferredUpdateMessage)
  Autocomplete(Autocomplete)
  Modal(Modal(modal), modal_to_json)
}

pub fn json(response: Response(_, _)) {
  case response {
    Pong -> [#("type", json.int(1))] |> json.object
    MessageWithSource(m) ->
      [
        #("type", json.int(4)),
        #("data", message.new_json(m)),
      ]
      |> json.object
    DeferredMessageWithSource(_) -> todo
    UpdateMessage(m) ->
      [#("type", json.int(7)), #("data", message.new_json(m))] |> json.object
    DeferredUpdateMessage(_) -> todo
    Autocomplete(a) ->
      [
        #("type", json.int(8)),
        #("data", autocomplete_json(a)),
      ]
      |> json.object
    Modal(m, to_json) -> to_json(m)
  }
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

fn autocomplete_json(autocomplete: Autocomplete) -> Json {
  [
    #("choices", case autocomplete {
      StringAutocomplete(a) -> json.array(a, string_choice_json)
      IntegerAutocomplete(a) -> json.array(a, integer_choice_json)
      NumberAutocomplete(a) -> json.array(a, number_choice_json)
    }),
  ]
  |> json.object
}

fn string_choice_json(choice: #(String, String)) {
  [#("name", json.string(choice.0)), #("value", json.string(choice.1))]
  |> json.object
}

fn integer_choice_json(choice: #(String, Int)) {
  [#("name", json.string(choice.0)), #("value", json.int(choice.1))]
  |> json.object
}

fn number_choice_json(choice: #(String, Float)) {
  [#("name", json.string(choice.0)), #("value", json.float(choice.1))]
  |> json.object
}
