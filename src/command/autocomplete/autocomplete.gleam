import credentials.{type Credentials}
import gleam/dict.{type Dict}
import gleam/option.{type Option}
import interaction
import resolved.{type Resolved}

pub type Response {
  JsonString(String)
}

pub type Error {
  NotImplemented
}

pub type Data(option) {
  Data(
    id: String,
    name: String,
    resolved: Resolved,
    options: Dict(String, option),
    guild_id: Option(String),
  )
}

/// TODO figure out how to run this???
pub type Handler(option, ctx, val) =
  fn(interaction.AppCommandAutocomplete(Data(option)), Credentials, ctx, val) ->
    Result(Response, Error)

pub fn default_handler(_, _, _, _) {
  Error(NotImplemented)
}
