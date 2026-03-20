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
      case command.find_handler(bot.commands, i) {
        Ok(_h) -> Ok(todo as "execute handler")
        _ -> Error(Nil)
      }
    interaction.MessageComponent(..) -> Ok(todo as "execute component")
    interaction.ApplicationCommandAutocomplete(..) ->
      case command.find_autocomplete_handler(bot.commands, i) {
        Ok(_h) -> Ok(todo as "execute handler")
        _ -> Error(Nil)
      }
    interaction.ModalSubmit(..) -> Ok(todo as "handle submission")
  }
}
