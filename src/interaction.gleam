import gleam/dynamic.{type Dynamic}

pub type Interaction {
  Ping(id: String, application_id: String, token: String, version: Int)
  ApplicationCommand(
    id: String,
    application_id: String,
    data: Dynamic,
    token: String,
    version: Int,
  )
  MessageComponent
  ApplicationCommandAutocomplete
  ModalSubmit
}
