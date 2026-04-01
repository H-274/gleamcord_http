import gleam/dict.{type Dict}
import gleam/dynamic.{type Dynamic}
import gleam/list
import modal/interaction.{type Interaction}
import modal/response.{type Response}

pub opaque type Modal(state) {
  Modal(
    custom_id: String,
    title: String,
    components: Dict(String, Dynamic),
    handler: Handler(state),
  )
}

pub fn new(
  id custom_id: String,
  title title: String,
  components components: List(String),
  handler handler: Handler(_),
) {
  let components =
    list.map(components, fn(c) { #(c, dynamic.string(c)) }) |> dict.from_list
  Modal(custom_id:, title:, components:, handler:)
}

pub fn get_id(modal: Modal(_)) {
  modal.custom_id
}

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
