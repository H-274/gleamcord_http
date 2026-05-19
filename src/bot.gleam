import command/command.{type Command}
import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import interaction.{type Interaction}
import message_component/message_component.{type MessageComponent}
import modal/modal.{type Modal}
import response

pub opaque type Bot(state) {
  Bot(
    app_id: String,
    pub_key: String,
    token: String,
    state: state,
    commands: Dict(String, Command(state)),
    components: Dict(String, MessageComponent(state)),
    modals: Dict(String, Modal(state)),
  )
}

pub fn new(
  app_id app_id: String,
  pub_key pub_key: String,
  token token: String,
  state state: state,
) {
  Bot(
    app_id:,
    pub_key:,
    token:,
    state:,
    commands: dict.new(),
    components: dict.new(),
    modals: dict.new(),
  )
}

pub fn get_key(bot: Bot(_)) {
  bot.pub_key
}

pub fn commands(bot: Bot(_)) {
  bot.commands
}

pub fn add_command(bot: Bot(_), command command: Command(_)) {
  let tuple = command.to_tuple(command)
  let updated = dict.insert(bot.commands, tuple.0, tuple.1)

  Bot(..bot, commands: updated)
}

pub fn add_commands(bot: Bot(_), commands commands: List(Command(_))) {
  let new_commands = list.map(commands, command.to_tuple) |> dict.from_list
  let updated = dict.combine(bot.commands, new_commands, fn(_, b) { b })

  Bot(..bot, commands: updated)
}

pub fn components(bot bot: Bot(_)) {
  bot.components
}

pub fn add_component(
  bot bot: Bot(_),
  component component: MessageComponent(_),
) {
  let tuple = message_component.to_tuple(component)
  let updated = dict.insert(bot.components, tuple.0, tuple.1)

  Bot(..bot, components: updated)
}

pub fn add_components(
  bot bot: Bot(_),
  components components: List(MessageComponent(_)),
) {
  let new_components =
    list.map(components, message_component.to_tuple) |> dict.from_list
  let updated = dict.combine(bot.components, new_components, fn(_, b) { b })

  Bot(..bot, components: updated)
}

pub fn modals(bot bot: Bot(_)) {
  bot.modals
}

pub fn add_modal(bot bot: Bot(_), modal modal: Modal(_)) {
  let tuple = modal.to_tuple(modal)
  let updated = dict.insert(bot.modals, tuple.0, tuple.1)

  Bot(..bot, modals: updated)
}

pub fn add_modals(bot bot: Bot(_), modals modals: List(Modal(_))) {
  let new_modals = list.map(modals, modal.to_tuple) |> dict.from_list
  let updated = dict.combine(bot.modals, new_modals, fn(_, b) { b })

  Bot(..bot, modals: updated)
}

pub fn handle_interaction(bot bot: Bot(_), i interaction: Interaction) {
  case interaction {
    interaction.Ping(..) -> response.Pong |> Ok
    interaction.ApplicationCommand(i) ->
      command.handle_interaction(bot.commands, i, bot.state)
      |> result.map(command.map_response)
    interaction.MessageComponent(i) ->
      message_component.handle_interaction(bot.components, i, bot.state)
      |> result.map(message_component.map_response)
    interaction.ApplicationCommandAutocomplete(i) ->
      command.handle_autocomplete_interaction(bot.commands, i, bot.state)
      |> result.map(response.Autocomplete)
    interaction.ModalSubmit(i) ->
      modal.handle_interaction(bot.modals, i, bot.state)
      |> result.map(modal.map_response)
  }
}
