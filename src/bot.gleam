import application_commands.{type ApplicationCommand} as command
import gleam/erlang/process
import gleam/option.{type Option}
import interaction.{type Interaction}

pub type Bot(state) {
  Bot(
    app_id: String,
    pub_key: String,
    token: String,
    state: state,
    deferred_actor: Option(process.Name(fn() -> String)),
    commands: List(ApplicationCommand(state)),
    // TODO implement message component definitions
    components: List(Nil),
    // TODO implement modals definitions
    modals: List(Nil),
  )
}

pub fn handle_interaction(
  bot: Bot(_),
  i i: Interaction,
) -> Result(interaction.Response, Nil) {
  case i {
    interaction.Ping(..) -> Ok(interaction.Pong)
    interaction.ApplicationCommand(..) ->
      case command.execute_handler(bot.commands, bot.state, i) {
        Ok(_) as res -> res
        _ -> Error(Nil)
      }
    interaction.MessageComponent(..) -> Ok(todo as "execute component")
    interaction.ApplicationCommandAutocomplete(..) ->
      case command.find_execute_autocomplete(bot.commands, bot.state, i) {
        Ok(_) as res -> res
        _ -> Error(Nil)
      }
    interaction.ModalSubmit(..) -> Ok(todo as "handle submission")
  }
}
