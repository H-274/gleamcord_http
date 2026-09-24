import gleam/dict.{type Dict}
import gleam/result
import gleamcord_http.{type GleamcordCommand}
import gleamcord_http/discord

pub opaque type Bot {
  Bot(
    commands_dicts: Dict(String, gleamcord_http.CommandHandler),
    autocomplete_dicts: Dict(String, gleamcord_http.AutocompleteHandler),
    component_dicts: Dict(String, Nil),
    modal_dicts: Dict(String, Nil),
  )
}

pub fn bot() {
  Bot(
    commands_dicts: dict.new(),
    autocomplete_dicts: dict.new(),
    component_dicts: dict.new(),
    modal_dicts: dict.new(),
  )
}

pub fn set_commands(bot: Bot, commands: List(GleamcordCommand)) {
  let #(commands_dicts, autocomplete_dicts) =
    gleamcord_http.command_dicts(commands)
  Bot(..bot, commands_dicts:, autocomplete_dicts:)
}

pub fn add_commands(bot: Bot, commands: List(GleamcordCommand)) {
  let #(commands_dicts, autocomplete_dicts) =
    gleamcord_http.command_dicts(commands)
  Bot(
    ..bot,
    commands_dicts: dict.merge(bot.commands_dicts, commands_dicts),
    autocomplete_dicts: dict.merge(bot.autocomplete_dicts, autocomplete_dicts),
  )
}

pub fn remove_commands(bot: Bot, commands: List(GleamcordCommand)) {
  let #(commands_dicts, autocomplete_dicts) =
    gleamcord_http.command_dicts(commands)
  Bot(
    ..bot,
    commands_dicts: dict.drop(bot.commands_dicts, dict.keys(commands_dicts)),
    autocomplete_dicts: dict.drop(
      bot.autocomplete_dicts,
      dict.keys(autocomplete_dicts),
    ),
  )
}

pub fn handle_command(bot: Bot, interaction: discord.CommandInteraction) {
  let #(path, options) = todo as "Extract path from interaction"

  use handle <- result.try(dict.get(bot.commands_dicts, path))
  case handle {
    gleamcord_http.ChatCommandHandler(handle) -> handle(interaction, options)
    gleamcord_http.ContextCommandHandler(handle) -> handle(interaction)
  }
  |> Ok
}
