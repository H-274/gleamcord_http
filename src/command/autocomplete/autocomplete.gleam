import bot.{type Bot}
import interaction

pub type Response {
  JsonString(String)
}

pub type Error {
  NotImplemented
}

pub type Data(val) {
  Data(val)
}

pub type Handler(ctx, val) =
  fn(interaction.AppCommandAutocomplete(Data(val)), Bot, ctx, val) ->
    Result(Response, Error)

pub fn default_handler(_, _, _, _) {
  Error(NotImplemented)
}
