import bot.{type Bot}
import command/command_option.{type CommandOption}
import command/interaction.{type Interaction}

/// TODO
pub type Response {
  JsonString(String)
}

/// TODO
pub type Error {
  NotImplemented
  Silent(String)
  User(String)
}

/// TODO
pub type Handler(ctx) =
  fn(Interaction, Bot, ctx, CommandOption) -> Result(Response, Error)

pub fn undefined(_, _, _, _) {
  Error(NotImplemented)
}
