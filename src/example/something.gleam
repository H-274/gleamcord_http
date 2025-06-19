import command
import entities/integration
import entities/interaction_context
import entities/locale

pub fn something() {
  let command =
    command.message_command("Quote")
    |> command.message_name_locales([#(locale.French, "Cite")])
    |> command.message_integration_types([integration.GuildInstall])
    |> command.message_contexts([interaction_context.Guild])

  use _input <- command.message_execute(command)

  "Output"
}
