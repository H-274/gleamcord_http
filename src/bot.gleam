import application_commands.{type ApplicationCommand} as command
import gleam/dict.{type Dict}
import gleam/list
import gleam/result
import interaction.{type Interaction}
import interaction/data
import internal/type_utils
import response

pub type Bot(state) {
  Bot(
    app_id: String,
    pub_key: String,
    token: String,
    state: state,
    commands: Dict(String, ApplicationCommand(state)),
    // TODO implement message component definitions
    components: Dict(String, Nil),
    // TODO implement modals definitions
    modals: Dict(String, Nil),
  )
}

pub fn handle_interaction(
  bot: Bot(_),
  i i: Interaction,
) -> Result(response.Response, Nil) {
  case i {
    interaction.Ping(..) -> Ok(response.Pong)
    interaction.ApplicationCommand(data:, ..) ->
      command.handle_interaction(bot.commands, bot.state, i, data)
      |> result.map(response.Command)
    interaction.MessageComponent(data:, ..) ->
      handle_component(bot.components, bot.state, i, data)
    interaction.ApplicationCommandAutocomplete(data:, ..) ->
      handle_autocomplete(bot.commands, bot.state, i, data)
    interaction.ModalSubmit(data:, ..) ->
      handle_modal(bot.commands, bot.state, i, data)
  }
}

fn handle_component(components, state, i, data) {
  todo
}

fn handle_autocomplete(commands, state, i, data) {
  todo
}

fn handle_modal(modals, state, i, data) {
  todo
}
