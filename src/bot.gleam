import application_commands.{type ApplicationCommand} as command
import gleam/erlang/process
import gleam/option.{type Option}
import interaction.{type Interaction}
import response

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
) -> Result(response.Response, Nil) {
  case i {
    interaction.Ping(..) -> Ok(response.Pong)
    interaction.ApplicationCommand(..) -> Ok(todo as "execute command")
    interaction.MessageComponent(..) -> Ok(todo as "execute component")
    interaction.ApplicationCommandAutocomplete(..) ->
      todo as "execute autocomplete"
      |> response.Autocomplete
      |> Ok
    interaction.ModalSubmit(..) -> Ok(todo as "handle submission")
  }
}
