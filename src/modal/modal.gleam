import component/layout
import gleam/dict.{type Dict}
import gleam/json
import message
import modal/interaction.{type Interaction}
import response

pub opaque type Modal(state) {
  Modal(
    custom_id: String,
    title: String,
    components: List(layout.Label),
    handler: Handler(state),
  )
}

pub fn new(
  id custom_id: String,
  title title: String,
  components components: List(layout.Label),
  handler handler: Handler(_),
) {
  Modal(custom_id:, title:, components:, handler:)
}

pub fn to_tuple(modal modal: Modal(_)) {
  #(modal.custom_id, modal)
}

pub fn json(modal: Modal(_)) {
  let Modal(custom_id:, title:, components:, handler: _) = modal

  [
    #("custom_id", json.string(custom_id)),
    #("title", json.string(title)),
    #("components", json.array(components, layout.label_json)),
  ]
  |> json.object
}

// TODO eventually directly put values from resolved instead of string as dict value
pub type Handler(state) =
  fn(Interaction, state, Dict(String, String)) -> Response

pub type Response {
  MessageResponse(message.New)
  DeferredMessageResponse(fn() -> message.New)
  UpdateResponse(message.New)
  DeferredUpdateResponse(fn() -> message.New)
}

pub fn map_response(response response: Response) {
  case response {
    MessageResponse(r) -> response.MessageWithSource(r)
    DeferredMessageResponse(r) -> response.DeferredMessageWithSource(r)
    UpdateResponse(r) -> response.UpdateMessage(r)
    DeferredUpdateResponse(r) -> response.DeferredUpdateMessage(r)
  }
}

pub fn handle_interaction(
  modals: Dict(String, Modal(_)),
  i: Interaction,
  state: _,
) -> Result(Response, Nil) {
  case dict.get(modals, i.data.custom_id) {
    Ok(modal) -> modal.handler(i, state, i.data.components) |> Ok
    _ -> Error(Nil)
  }
}
