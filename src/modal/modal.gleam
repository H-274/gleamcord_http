import component/layout
import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
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

pub fn get_id(modal: Modal(_)) {
  modal.custom_id
}

/// TODO replace Dynamic with values type to represent variants for different custom IDs
pub type Handler(state) =
  fn(Interaction, state, Dict(String, Dynamic)) -> Response

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
