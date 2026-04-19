import command/command.{type Command}
import gleam/dict.{type Dict}
import gleam/result
import interaction.{type Interaction}
import message_component/message_component.{type MessageComponent}
import modal/modal.{type Modal}
import response.{type Response}

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

pub fn handle_interaction(
  bot: Bot(_),
  i i: Interaction,
) -> Result(Response(state), Nil) {
  case i {
    interaction.Ping(..) -> Ok(response.Pong)

    interaction.ApplicationCommand(i) ->
      command.run(bot.commands, bot.state, i)
      |> result.map(response.Command)

    interaction.MessageComponent(i) ->
      message_component.handle_interaction(bot.components, bot.state, i)
      |> result.map(response.MessageComponent)

    interaction.ApplicationCommandAutocomplete(i) ->
      command.run_autocomplete(bot.commands, i, bot.state)
      |> result.map(response.Autocomplete)

    interaction.ModalSubmit(i) ->
      modal.handle_interaction(bot.modals, bot.state, i)
      |> result.map(response.Modal)
  }
}
