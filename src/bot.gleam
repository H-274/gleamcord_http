import application_command/application_command.{type ApplicationCommand} as command
import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import interaction/interaction.{type Interaction}
import modal/modal.{type Modal}
import response.{type Response}

pub opaque type Bot(state) {
  Bot(
    app_id: String,
    pub_key: String,
    token: String,
    state: state,
    commands: Dict(String, ApplicationCommand(state)),
    // TODO implement message component definitions
    components: Dict(String, Nil),
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

pub fn add_command(
  bot: Bot(state),
  command: ApplicationCommand(state),
) -> Bot(state) {
  let pair = command.dict_pair(command)
  Bot(..bot, commands: dict.insert(bot.commands, pair.0, pair.1))
}

pub fn add_commands(
  bot: Bot(state),
  commands: List(ApplicationCommand(state)),
) -> Bot(state) {
  let pairs = list.map(commands, command.dict_pair)
  let new_commands = dict.merge(bot.commands, dict.from_list(pairs))

  Bot(..bot, commands: new_commands)
}

pub fn add_modal(bot: Bot(state), modal: Modal(state)) {
  Bot(..bot, modals: dict.insert(bot.modals, modal.get_id(modal), modal))
}

pub fn add_modals(bot: Bot(state), modals: List(Modal(state))) {
  let pairs = list.map(modals, fn(m) { #(modal.get_id(m), m) })
  let new_modals = dict.merge(bot.modals, dict.from_list(pairs))

  Bot(..bot, modals: new_modals)
}

pub fn handle_interaction(
  bot: Bot(_),
  i i: Interaction,
) -> Result(Response(state), Nil) {
  case i {
    interaction.Ping(..) -> Ok(response.Pong)

    interaction.ApplicationCommand(i) ->
      command.handle_interaction(bot.commands, bot.state, i)
      |> result.map(response.Command)

    interaction.MessageComponent(..) -> todo

    interaction.ApplicationCommandAutocomplete(i) ->
      command.handle_autocomplete_interaction(bot.commands, bot.state, i)
      |> result.map(response.Autocomplete)

    interaction.ModalSubmit(i) ->
      modal.handle_interaction(bot.modals, bot.state, i)
      |> result.map(response.Modal)
  }
}
