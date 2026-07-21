import command/command.{type Command}
import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import interaction.{type Interaction}
import locale
import message_component/message_component.{type MessageComponent}
import modal/modal.{type Modal}
import response

pub opaque type Bot(credentials, state) {
  Bot(
    credentials: credentials,
    state: state,
    commands: Dict(String, Command(state)),
    components: Dict(String, MessageComponent(state)),
    modals: Dict(String, Modal(state)),
  )
  LocalizedBot(
    credentials: credentials,
    state: state,
    commands: Dict(String, Command(state)),
    components: Dict(String, MessageComponent(state)),
    modals: Dict(String, Modal(state)),
    translator: locale.Translator,
  )
}

pub fn new(creds credentials: credentials, state state: state) {
  Bot(
    credentials:,
    state:,
    commands: dict.new(),
    components: dict.new(),
    modals: dict.new(),
  )
}

pub fn new_localized(
  creds credentials,
  state state,
  translator translator: locale.Translator,
) {
  LocalizedBot(
    credentials:,
    state:,
    commands: dict.new(),
    components: dict.new(),
    modals: dict.new(),
    translator:,
  )
}

pub fn credentials(bot: Bot(_, _)) {
  bot.credentials
}

pub fn commands(bot: Bot(_, _)) {
  bot.commands
}

pub fn add_command(bot: Bot(_, _), command command: Command(_)) {
  let tuple = command.to_tuple(command)
  let updated = dict.insert(bot.commands, tuple.0, tuple.1)

  case bot {
    Bot(..) -> Bot(..bot, commands: updated)
    LocalizedBot(..) -> LocalizedBot(..bot, commands: updated)
  }
}

pub fn add_commands(bot: Bot(_, _), commands commands: List(Command(_))) {
  let new_commands = list.map(commands, command.to_tuple) |> dict.from_list
  let updated = dict.combine(bot.commands, new_commands, fn(_, b) { b })

  case bot {
    Bot(..) -> Bot(..bot, commands: updated)
    LocalizedBot(..) -> LocalizedBot(..bot, commands: updated)
  }
}

pub fn components(bot bot: Bot(_, _)) {
  bot.components
}

pub fn add_component(
  bot bot: Bot(_, _),
  component component: MessageComponent(_),
) {
  let tuple = message_component.to_tuple(component)
  let updated = dict.insert(bot.components, tuple.0, tuple.1)

  case bot {
    Bot(..) -> Bot(..bot, components: updated)
    LocalizedBot(..) -> LocalizedBot(..bot, components: updated)
  }
}

pub fn add_components(
  bot bot: Bot(_, _),
  components components: List(MessageComponent(_)),
) {
  let new_components =
    list.map(components, message_component.to_tuple) |> dict.from_list
  let updated = dict.combine(bot.components, new_components, fn(_, b) { b })

  case bot {
    Bot(..) -> Bot(..bot, components: updated)
    LocalizedBot(..) -> LocalizedBot(..bot, components: updated)
  }
}

pub fn modals(bot bot: Bot(_, _)) {
  bot.modals
}

pub fn add_modal(bot bot: Bot(_, _), modal modal: Modal(_)) {
  let tuple = modal.to_tuple(modal)
  let updated = dict.insert(bot.modals, tuple.0, tuple.1)

  case bot {
    Bot(..) -> Bot(..bot, modals: updated)
    LocalizedBot(..) -> LocalizedBot(..bot, modals: updated)
  }
}

pub fn add_modals(bot bot: Bot(_, _), modals modals: List(Modal(_))) {
  let new_modals = list.map(modals, modal.to_tuple) |> dict.from_list
  let updated = dict.combine(bot.modals, new_modals, fn(_, b) { b })

  case bot {
    Bot(..) -> Bot(..bot, modals: updated)
    LocalizedBot(..) -> LocalizedBot(..bot, modals: updated)
  }
}

pub fn handle_interaction(bot bot: Bot(_, _), i interaction: Interaction) {
  case interaction {
    interaction.Ping(..) -> response.Pong |> Ok
    interaction.ApplicationCommand(i) ->
      command.handle_interaction(bot.commands, i, bot.state)
      |> result.map(response.map_command)
    interaction.MessageComponent(i) ->
      message_component.handle_interaction(bot.components, i, bot.state)
      |> result.map(response.map_message_component)
    interaction.ApplicationCommandAutocomplete(i) ->
      command.handle_autocomplete_interaction(bot.commands, i, bot.state)
      |> result.map(response.Autocomplete)
    interaction.ModalSubmit(i) ->
      modal.handle_interaction(bot.modals, i, bot.state)
      |> result.map(response.map_modal)
  }
}
