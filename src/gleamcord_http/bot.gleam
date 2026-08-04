import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import gleamcord_http.{type Modal}
import gleamcord_http/command.{type Command}
import gleamcord_http/interaction.{type Interaction}
import gleamcord_http/message_component.{type MessageComponent}
import gleamcord_http/response

pub opaque type Bot {
  Bot(
    commands: Dict(String, Command),
    components: Dict(String, MessageComponent),
    modals: Dict(String, Modal),
  )
}

pub fn new() {
  Bot(commands: dict.new(), components: dict.new(), modals: dict.new())
}

pub fn commands(bot: Bot) {
  bot.commands
}

pub fn add_command(bot: Bot, command command: Command) {
  let tuple = command.to_tuple(command)
  let updated = dict.insert(bot.commands, tuple.0, tuple.1)

  Bot(..bot, commands: updated)
}

pub fn add_commands(bot: Bot, commands commands: List(Command)) {
  let new_commands = list.map(commands, command.to_tuple) |> dict.from_list
  let updated = dict.combine(bot.commands, new_commands, fn(_, b) { b })

  Bot(..bot, commands: updated)
}

pub fn components(bot bot: Bot) {
  bot.components
}

pub fn add_component(bot bot: Bot, component component: MessageComponent) {
  let tuple = message_component.to_tuple(component)
  let updated = dict.insert(bot.components, tuple.0, tuple.1)

  Bot(..bot, components: updated)
}

pub fn add_components(
  bot bot: Bot,
  components components: List(MessageComponent),
) {
  let new_components =
    list.map(components, message_component.to_tuple) |> dict.from_list
  let updated = dict.combine(bot.components, new_components, fn(_, b) { b })

  Bot(..bot, components: updated)
}

pub fn modals(bot bot: Bot) {
  bot.modals
}

pub fn add_modal(bot bot: Bot, modal modal: Modal) {
  let tuple = gleamcord_http.modal_tuple(modal)
  let updated = dict.insert(bot.modals, tuple.0, tuple.1)

  Bot(..bot, modals: updated)
}

pub fn add_modals(bot bot: Bot, modals modals: List(Modal)) {
  let new_modals =
    list.map(modals, gleamcord_http.modal_tuple) |> dict.from_list
  let updated = dict.combine(bot.modals, new_modals, fn(_, b) { b })

  Bot(..bot, modals: updated)
}

pub fn handle_interaction(bot bot: Bot, i interaction: Interaction) {
  case interaction {
    interaction.Ping(..) -> response.Pong |> Ok
    interaction.ApplicationCommand(i) ->
      command.handle_interaction(bot.commands, i)
      |> result.map(response.map_command)
    interaction.MessageComponent(i) ->
      message_component.handle_interaction(bot.components, i)
      |> result.map(response.map_message_component)
    interaction.ApplicationCommandAutocomplete(i) ->
      command.handle_autocomplete_interaction(bot.commands, i)
      |> result.map(response.Autocomplete)
    interaction.ModalSubmit(i) ->
      gleamcord_http.handle_modal_interaction(bot.modals, i)
      |> result.map(response.map_modal)
  }
}
