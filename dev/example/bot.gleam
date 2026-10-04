import gleam/bool
import gleam/dict.{type Dict}
import gleam/list
import gleam/option
import gleam/result
import gleamcord_http
import gleamcord_http/discord

pub opaque type Bot {
  Bot(
    commands: Dict(String, gleamcord_http.GleamcordCommand),
    components: Dict(String, gleamcord_http.GleamcordComponent),
    modals: Dict(String, gleamcord_http.GleamcordModal),
    command_handler_dict: Dict(String, gleamcord_http.CommandHandler),
    autocomplete_handler_dict: Dict(String, gleamcord_http.AutocompleteHandler),
    component_handler_dict: Dict(String, gleamcord_http.ComponentHandler),
    modal_handler_dict: Dict(String, gleamcord_http.ModalHandler),
  )
}

pub fn bot() -> Bot {
  Bot(
    commands: dict.new(),
    components: dict.new(),
    modals: dict.new(),
    command_handler_dict: dict.new(),
    autocomplete_handler_dict: dict.new(),
    component_handler_dict: dict.new(),
    modal_handler_dict: dict.new(),
  )
}

pub fn commands(bot: Bot) -> Dict(String, gleamcord_http.GleamcordCommand) {
  bot.commands
}

pub fn set_commands(
  bot: Bot,
  commands: List(gleamcord_http.GleamcordCommand),
) -> Bot {
  let #(command_handler_dict, autocomplete_handler_dict) =
    gleamcord_http.command_dicts(commands)
  let commands =
    dict.from_list(list.map(commands, fn(c) { #(c.definition.name, c) }))

  Bot(..bot, commands:, command_handler_dict:, autocomplete_handler_dict:)
}

/// Add the list of commands to the bot, and updating dicts, ensuring that no commands are overwritten.
pub fn add_commands_safe(
  bot: Bot,
  new: List(gleamcord_http.GleamcordCommand),
) -> Result(Bot, Nil) {
  let Bot(commands:, command_handler_dict:, autocomplete_handler_dict:, ..) =
    bot
  let new_handler_dicts = gleamcord_http.command_dicts(new)

  let command_collision =
    list.any(new, fn(n) { dict.has_key(commands, n.definition.name) })
  use <- bool.guard(command_collision, Error(Nil))

  let new = dict.from_list(list.map(new, fn(n) { #(n.definition.name, n) }))

  let commands = dict.merge(commands, new)
  let command_handler_dict =
    dict.merge(command_handler_dict, new_handler_dicts.0)
  let autocomplete_handler_dict =
    dict.merge(autocomplete_handler_dict, new_handler_dicts.1)

  Ok(Bot(..bot, commands:, command_handler_dict:, autocomplete_handler_dict:))
}

/// Add the list of commands to the bot, overwriting old commands, and updating dicts
pub fn add_commands(
  bot: Bot,
  new: List(gleamcord_http.GleamcordCommand),
) -> Result(Bot, a) {
  let Bot(commands:, command_handler_dict:, autocomplete_handler_dict:, ..) =
    bot
  let new_handler_dicts = gleamcord_http.command_dicts(new)
  let new = dict.from_list(list.map(new, fn(n) { #(n.definition.name, n) }))

  let collisions =
    list.map(dict.keys(new), dict.get(commands, _)) |> result.values
  let collision_dicts = gleamcord_http.command_dicts(collisions)

  let commands = dict.merge(commands, new)
  let command_handler_dict =
    dict.drop(command_handler_dict, dict.keys(collision_dicts.0))
    |> dict.merge(new_handler_dicts.0)
  let autocomplete_handler_dict =
    dict.drop(autocomplete_handler_dict, dict.keys(collision_dicts.1))
    |> dict.merge(new_handler_dicts.1)

  Ok(Bot(..bot, commands:, command_handler_dict:, autocomplete_handler_dict:))
}

pub fn set_components(
  bot: Bot,
  components: List(gleamcord_http.GleamcordComponent),
) -> Bot {
  let component_handler_dict = gleamcord_http.components_dict(components)
  let components =
    dict.from_list(list.map(components, gleamcord_http.component_tuple))

  Bot(..bot, components:, component_handler_dict:)
}

pub fn set_modals(
  bot: Bot,
  modals: List(gleamcord_http.GleamcordModal),
) -> Bot {
  let modal_handler_dict =
    dict.from_list(list.map(modals, fn(m) { #(m.custom_id, m.handler) }))
  let modals = dict.from_list(list.map(modals, fn(m) { #(m.custom_id, m) }))

  Bot(..bot, modals:, modal_handler_dict:)
}

pub fn handle_command(
  bot: Bot,
  interaction: discord.CommandInteraction,
) -> gleamcord_http.CommandResponse {
  let #(path, options) = todo as "grab interaction path and options"

  case dict.get(bot.command_handler_dict, path), options {
    Ok(gleamcord_http.ChatCommandHandler(handler)), option.Some(o) ->
      handler(interaction, o)
    Ok(gleamcord_http.ContextCommandHandler(handler)), option.None ->
      handler(interaction)
    _, _ -> todo as "Command not found"
  }
}

pub fn handle_component(
  bot: Bot,
  interaction: discord.ComponentInteraction,
) -> gleamcord_http.ComponentResponse {
  let #(custom_id, values) = todo as "grab component custom_id and values"

  case dict.get(bot.component_handler_dict, custom_id), values {
    Ok(gleamcord_http.ComponentButtonHandler(handler)), option.None ->
      handler(interaction)
    Ok(gleamcord_http.ComponentSelectHandler(handler)), option.Some(v) ->
      handler(interaction, v)
    _, _ -> todo as "Component not found"
  }
}

pub fn handle_modal(
  bot: Bot,
  interaction: discord.ModalInteraction,
) -> gleamcord_http.ModalResponse {
  let #(custom_id, values) = todo as "grab modal custom_id and values"

  case dict.get(bot.modal_handler_dict, custom_id) {
    Ok(handler) -> handler(interaction, values)
    Error(_) -> todo as "Modal not found"
  }
}
