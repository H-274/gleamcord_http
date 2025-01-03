import bot.{type Bot}
import command/interaction.{type Interaction}
import gleam/dict.{type Dict}

/// TODO
pub type CommandResponse {
  JsonString(String)
}

/// TODO
pub type CommandError {
  NotImplemented
  Silent(String)
  User(String)
}

/// TODO
pub type AutocompleteResponse {
  AutocompleteResponse
}

pub type ChatInputHandler(ctx, option) =
  fn(Interaction, Bot, ctx, Dict(String, option)) ->
    Result(CommandResponse, CommandError)

pub type UserHandler(ctx) =
  fn(Interaction, Bot, ctx) -> Result(CommandResponse, CommandError)

pub type MessageHandler(ctx) =
  fn(Interaction, Bot, ctx) -> Result(CommandResponse, CommandError)

pub type AutocompleteHandler(ctx, option) =
  fn(Interaction, Bot, ctx, Dict(String, option)) ->
    Result(AutocompleteResponse, Nil)

pub fn chat_input_undefined(_, _, _, _) {
  Error(NotImplemented)
}

pub fn user_undefined(_, _, _) {
  Error(NotImplemented)
}

pub fn message_undefined(_, _, _) {
  Error(NotImplemented)
}
