import application_command/application_command.{type ApplicationCommand} as command
import gleam/dict.{type Dict}
import gleam/result
import interaction/interaction.{type Interaction}
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

    interaction.ApplicationCommand(i) ->
      command.handle_interaction(bot.commands, bot.state, i)
      |> result.map(response.Command)

    interaction.MessageComponent(..) -> todo

    interaction.ApplicationCommandAutocomplete(i) ->
      command.handle_autocomplete_interaction(bot.commands, bot.state, i)
      |> result.map(response.Autocomplete)

    interaction.ModalSubmit(..) -> todo
  }
}
