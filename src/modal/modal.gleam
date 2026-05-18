import component/layout
import gleam/dict.{type Dict}
import gleam/json
import modal/interaction.{type Interaction}
import modal/response.{type Response}

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

// TODO eventually directly put values from resolved instead of string as dict value
pub type Handler(state) =
  fn(Interaction, state, Dict(String, String)) -> Response

pub fn handle_interaction(
  modals: Dict(String, Modal(state)),
  state: state,
  i: Interaction,
) -> Result(Response, Nil) {
  case dict.get(modals, i.data.custom_id) {
    Ok(modal) -> modal.handler(i, state, i.data.components) |> Ok
    _ -> Error(Nil)
  }
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
