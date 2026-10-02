import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/string
import gleamcord_http
import gleamcord_http/discord

pub opaque type Bot {
  Bot(
    commands: List(gleamcord_http.GleamcordCommand),
    components: List(gleamcord_http.GleamcordComponent),
    modals: List(gleamcord_http.GleamcordModal),
    command_handler_dict: Dict(String, gleamcord_http.CommandHandler),
    autocomplete_handler_dict: Dict(String, gleamcord_http.AutocompleteHandler),
    component_handler_dict: Dict(String, gleamcord_http.ComponentHandler),
    modal_handler_dict: Dict(String, gleamcord_http.ModalHandler),
  )
}

pub fn bot() {
  Bot(
    commands: [],
    components: [],
    modals: [],
    command_handler_dict: dict.new(),
    autocomplete_handler_dict: dict.new(),
    component_handler_dict: dict.new(),
    modal_handler_dict: dict.new(),
  )
}

pub fn commands(bot: Bot) {
  bot.commands
}

pub fn set_commands(bot: Bot, commands: List(gleamcord_http.GleamcordCommand)) {
  let dicts = gleamcord_http.command_dicts(commands)

  Bot(
    ..bot,
    commands:,
    command_handler_dict: dicts.0,
    autocomplete_handler_dict: dicts.1,
  )
}

/// Add the list of commands to the bot, ensuring that no commands are overwritten.
pub fn add_commands_safe(bot: Bot, new: List(gleamcord_http.GleamcordCommand)) {
  let Bot(commands:, command_handler_dict:, autocomplete_handler_dict:, ..) =
    bot
  let new_dicts = gleamcord_http.command_dicts(new)

  let command_key_collision =
    list.any(dict.keys(new_dicts.0), fn(k) {
      dict.has_key(command_handler_dict, k)
    })
  use <- bool.guard(command_key_collision, Error(Nil))

  Bot(
    ..bot,
    commands: list.append(commands, new),
    command_handler_dict: dict.merge(command_handler_dict, new_dicts.0),
    autocomplete_handler_dict: dict.merge(
      autocomplete_handler_dict,
      new_dicts.1,
    ),
  )
  |> Ok
}

/// Add the list of commands to the bot, overwritting old commands, and pruning old autocomplete handlers.
pub fn add_commands(bot: Bot, new: List(gleamcord_http.GleamcordCommand)) {
  let Bot(commands:, command_handler_dict:, autocomplete_handler_dict:, ..) =
    bot
  let new_dicts = gleamcord_http.command_dicts(new)

  let command_collisions =
    list.filter(dict.keys(new_dicts.0), fn(k) {
      dict.has_key(command_handler_dict, k)
    })

  let command_handler_dict = dict.drop(command_handler_dict, command_collisions)
  let autocomplete_handler_dict =
    dict.drop(
      autocomplete_handler_dict,
      list.filter(dict.keys(autocomplete_handler_dict), fn(k) {
        list.any(command_collisions, string.starts_with(k, _))
      }),
    )

  Bot(
    ..bot,
    commands: list.append(commands, new),
    command_handler_dict: dict.merge(command_handler_dict, new_dicts.0),
    autocomplete_handler_dict: dict.merge(
      autocomplete_handler_dict,
      new_dicts.1,
    ),
  )
  |> Ok
}

pub fn handle_command(bot: Bot, interaction: discord.CommandInteraction) {
  let #(path, options) = todo as "grab interaction path and options"

  case dict.get(bot.command_handler_dict, path) {
    Ok(gleamcord_http.ChatCommandHandler(handler)) ->
      handler(interaction, options)
    Ok(gleamcord_http.ContextCommandHandler(handler)) -> handler(interaction)
    Error(_) -> todo as "Command not found"
  }
}
